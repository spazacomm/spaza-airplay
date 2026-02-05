<script lang="ts">
    import { fly, fade } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // logs from Supabase
    let logs = $state(data.logs || []);

    $effect(() => {
        if (data.logs) {
            logs = data.logs;
        }
    });

    // Filter State
    let searchQuery = $state("");
    let filterStatus = $state("All");
    let filterSource = $state("All");
    let filterDate = $state("Last 24 Hours");

    const statuses = ["All", "verified", "pending", "flagged"];
    const sources = [
        "All",
        "Classic 105",
        "Radio Citizen",
        "NRG Radio",
        "Capital FM",
        "Radio Maisha",
        "Kiss FM",
    ];
    const dateRanges = [
        "Last 24 Hours",
        "Last 7 Days",
        "Last 30 Days",
        "Custom Range",
    ];

    // Pagination State
    let currentPage = $state(1);
    let itemsPerPage = $state(15);

    // Derived filtered logs
    let filteredLogs = $derived(
        logs.filter((l) => {
            const matchSearch =
                l.song.toLowerCase().includes(searchQuery.toLowerCase()) ||
                l.artist.toLowerCase().includes(searchQuery.toLowerCase());
            const matchStatus =
                filterStatus === "All" || l.status === filterStatus;
            const matchSource =
                filterSource === "All" || l.broadcaster === filterSource;

            return matchSearch && matchStatus && matchSource;
        }),
    );

    // Derived paginated logs
    let totalPages = $derived(Math.ceil(filteredLogs.length / itemsPerPage));
    let paginatedLogs = $derived(
        filteredLogs.slice(
            (currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage,
        ),
    );

    // Reset pagination when filters change
    $effect(() => {
        // Accessing filter states to trigger effect
        const _query = searchQuery;
        const _status = filterStatus;
        const _source = filterSource;
        const _date = filterDate;
        currentPage = 1;
    });

    // Selection & Inspector State
    let selectedLogId = $state<string | null>(null);
    let isInspectorOpen = $state(false);
    let isPlaying = $state(false);

    let selectedLog = $derived(logs.find((l) => l.id === selectedLogId));

    function openInspector(id: string) {
        selectedLogId = id;
        isInspectorOpen = true;
        isPlaying = false;
    }

    function closeInspector() {
        isInspectorOpen = false;
        setTimeout(() => (selectedLogId = null), 300);
    }

    function togglePlayback() {
        isPlaying = !isPlaying;
    }

    function formatStatus(status: string) {
        return status.charAt(0).toUpperCase() + status.slice(1);
    }

    function resetFilters() {
        searchQuery = "";
        filterStatus = "All";
        filterSource = "All";
        filterDate = "Last 24 Hours";
        currentPage = 1;
    }

    function changePage(page: number) {
        if (page >= 1 && page <= totalPages) {
            currentPage = page;
        }
    }
</script>

<svelte:head>
    <title>Play Logs | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <!-- Header -->
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-white/95 backdrop-blur-sm z-30 px-8 flex flex-col justify-center"
    >
        <!-- Breadcrumb -->
        <nav class="flex items-center gap-2 mb-1">
            <a
                href="/dashboard"
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted hover:text-primary transition-colors"
                >Dashboard</a
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Airplay Logs</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-background-dark border border-border-dark flex items-center justify-center text-primary shadow-saas-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >history</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-text-primary tracking-tight leading-none"
                    >
                        Detection History
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Verify and audit real-time radio airplay detections
                    </p>
                </div>
            </div>

            <div class="flex items-center gap-3">
                <button
                    class="h-9 px-4 btn-secondary rounded-lg flex items-center gap-2 transition-all"
                >
                    <span class="material-symbols-outlined text-lg"
                        >download</span
                    >
                    <span class="text-xs font-bold uppercase tracking-wider"
                        >Export Report</span
                    >
                </button>
            </div>
        </div>
    </header>

    <!-- Filters Toolbar -->
    <div
        class="h-14 shrink-0 border-b border-border-dark bg-white/50 px-8 flex items-center gap-4 z-20 overflow-x-auto scrollbar-none"
    >
        <div class="relative group min-w-[200px]">
            <span
                class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-text-muted text-lg"
                >search</span
            >
            <input
                type="text"
                placeholder="Search tracks or artists..."
                class="h-8 w-full bg-background-dark border border-border-dark rounded-md pl-9 pr-4 text-xs text-text-primary placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary focus:border-primary transition-all font-medium"
                bind:value={searchQuery}
            />
        </div>

        <div class="h-6 w-px bg-border-dark mx-2"></div>

        <div class="flex items-center gap-3">
            <div class="relative">
                <select
                    class="h-8 w-36 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterDate}
                >
                    {#each dateRanges as d}
                        <option value={d}>{d}</option>
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >event</span
                >
            </div>

            <div class="relative">
                <select
                    class="h-8 w-36 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterSource}
                >
                    {#each sources as s}
                        <option value={s}
                            >{s === "All" ? "All Sources" : s}</option
                        >
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >radio</span
                >
            </div>

            <div class="relative">
                <select
                    class="h-8 w-32 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterStatus}
                >
                    {#each statuses as s}
                        <option value={s}
                            >{s === "All"
                                ? "All Status"
                                : formatStatus(s)}</option
                        >
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >expand_more</span
                >
            </div>
        </div>

        {#if searchQuery || filterStatus !== "All" || filterSource !== "All"}
            <button
                class="ml-auto text-[10px] text-primary font-bold uppercase tracking-widest hover:underline"
                onclick={resetFilters}
            >
                Clear All
            </button>
        {/if}
    </div>

    <!-- Table Content -->
    <main class="flex-1 overflow-auto relative">
        <table class="w-full text-left border-collapse">
            <thead class="sticky top-0 z-10 bg-background-dark shadow-sm">
                <tr>
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[20%]"
                        >Timestamp</th
                    >
                    <th
                        class="py-3 px-6 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[30%]"
                        >Track & Artist</th
                    >
                    <th
                        class="py-3 px-6 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Broadcaster</th
                    >
                    <th
                        class="py-3 px-6 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Confidence</th
                    >
                    <th
                        class="py-3 px-6 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[10%]"
                        >Status</th
                    >
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark text-right w-[10%]"
                        >Royalty</th
                    >
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark/50 bg-white">
                {#each paginatedLogs as log}
                    <tr
                        class="group hover:bg-background-dark transition-colors cursor-pointer"
                        onclick={() => openInspector(log.id)}
                    >
                        <td
                            class="py-4 px-8 text-xs font-mono text-text-secondary"
                        >
                            {log.timestamp}
                        </td>
                        <td class="py-4 px-6">
                            <div class="flex flex-col">
                                <span
                                    class="text-sm font-semibold text-text-primary group-hover:text-primary transition-colors"
                                    >{log.song}</span
                                >
                                <span
                                    class="text-[11px] text-text-muted font-medium"
                                    >{log.artist}</span
                                >
                            </div>
                        </td>
                        <td class="py-4 px-6">
                            <div class="flex items-center gap-2">
                                <span
                                    class="material-symbols-outlined text-base text-text-muted"
                                    >radio</span
                                >
                                <span
                                    class="text-xs text-text-secondary font-medium"
                                    >{log.broadcaster}</span
                                >
                            </div>
                        </td>
                        <td class="py-4 px-6">
                            <div class="flex items-center gap-2.5">
                                <div
                                    class="w-16 h-1.5 bg-surface-darker rounded-full overflow-hidden border border-border-dark/50"
                                >
                                    <div
                                        class="h-full rounded-full {log.confidence >
                                        0.9
                                            ? 'bg-emerald-500'
                                            : log.confidence > 0.7
                                              ? 'bg-amber-500'
                                              : 'bg-red-500'}"
                                        style="width: {log.confidence * 100}%"
                                    ></div>
                                </div>
                                <span
                                    class="text-[10px] font-mono font-bold {log.confidence >
                                    0.9
                                        ? 'text-emerald-400'
                                        : log.confidence > 0.7
                                          ? 'text-amber-400'
                                          : 'text-red-400'}"
                                >
                                    {(log.confidence * 100).toFixed(0)}%
                                </span>
                            </div>
                        </td>
                        <td class="py-4 px-6">
                            <span
                                class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider {log.status ===
                                'verified'
                                    ? 'bg-emerald-500/10 text-emerald-400'
                                    : log.status === 'pending'
                                      ? 'bg-amber-500/10 text-amber-400'
                                      : 'bg-red-500/10 text-red-500'}"
                            >
                                {log.status}
                            </span>
                        </td>
                        <td class="py-4 px-8 text-right">
                            <span
                                class="text-sm font-mono font-bold text-text-primary"
                                >${log.royalty.toFixed(2)}</span
                            >
                        </td>
                    </tr>
                {:else}
                    <tr>
                        <td colspan="6" class="py-32 text-center">
                            <div
                                class="flex flex-col items-center justify-center opacity-30"
                            >
                                <span
                                    class="material-symbols-outlined text-5xl mb-3"
                                    >search_off</span
                                >
                                <p class="text-sm font-medium">
                                    No play logs found matching your criteria
                                </p>
                                <button
                                    class="mt-4 text-xs text-primary font-bold uppercase tracking-widest hover:underline"
                                    onclick={resetFilters}>Clear Filters</button
                                >
                            </div>
                        </td>
                    </tr>
                {/each}
            </tbody>
        </table>
    </main>

    <!-- Footer with Pagination -->
    <footer
        class="shrink-0 border-t border-border-dark bg-white px-8 py-3 flex items-center justify-between z-20"
    >
        <div
            class="text-[10px] font-mono text-text-muted uppercase tracking-widest"
        >
            Showing {(currentPage - 1) * itemsPerPage + 1}-{Math.min(
                currentPage * itemsPerPage,
                filteredLogs.length,
            )} of {filteredLogs.length} detections
        </div>

        <div class="flex items-center gap-2">
            <button
                class="size-8 flex items-center justify-center rounded border border-border-dark bg-background-dark text-text-muted hover:text-primary disabled:opacity-30 disabled:cursor-not-allowed transition-all shadow-saas-sm"
                onclick={() => changePage(currentPage - 1)}
                disabled={currentPage === 1}
            >
                <span class="material-symbols-outlined text-lg"
                    >chevron_left</span
                >
            </button>

            <div class="flex items-center gap-1">
                {#each Array.from( { length: Math.min(5, totalPages) }, (_, i) => {
                        if (totalPages <= 5) return i + 1;
                        if (currentPage <= 3) return i + 1;
                        if (currentPage >= totalPages - 2) return totalPages - 4 + i;
                        return currentPage - 2 + i;
                    }, ) as page}
                    <button
                        class="size-8 flex items-center justify-center rounded text-[10px] font-bold border transition-all {currentPage ===
                        page
                            ? 'bg-primary border-primary text-background-dark shadow-lg shadow-primary/20'
                            : 'bg-surface-darker border-border-dark text-text-muted hover:text-text-main'}"
                        onclick={() => changePage(page)}
                    >
                        {page}
                    </button>
                {/each}
            </div>

            <button
                class="size-8 flex items-center justify-center rounded border border-border-dark bg-background-dark text-text-muted hover:text-primary disabled:opacity-30 disabled:cursor-not-allowed transition-all shadow-saas-sm"
                onclick={() => changePage(currentPage + 1)}
                disabled={currentPage === totalPages}
            >
                <span class="material-symbols-outlined text-lg"
                    >chevron_right</span
                >
            </button>
        </div>

        <div
            class="flex gap-4 text-[10px] font-mono uppercase tracking-widest text-text-muted"
        >
            <span class="flex items-center gap-1.5"
                ><span class="size-2 rounded-sm bg-emerald-500"></span> Verified</span
            >
            <span class="flex items-center gap-1.5"
                ><span class="size-2 rounded-sm bg-amber-500"></span> Pending</span
            >
            <span class="flex items-center gap-1.5"
                ><span class="size-2 rounded-sm bg-red-500"></span> Flagged</span
            >
        </div>
    </footer>

    <!-- Play Log Inspector Offcanvas -->
    {#if isInspectorOpen && selectedLog}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={closeInspector}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[550px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <!-- Header -->
            <div class="p-8 border-b border-border-dark bg-surface-darker/30">
                <div class="flex justify-between items-start mb-6">
                    <div class="flex flex-col gap-1">
                        <span
                            class="px-2 py-0.5 rounded-full border border-border-dark bg-surface-darker text-[9px] font-bold uppercase tracking-wider text-text-secondary w-fit"
                        >
                            Detections ID: {selectedLog.id}
                        </span>
                        <h2
                            class="text-2xl font-bold text-text-main tracking-tight mt-2"
                        >
                            {selectedLog.song}
                        </h2>
                        <p
                            class="text-primary font-bold tracking-wide uppercase text-xs"
                        >
                            {selectedLog.artist}
                        </p>
                    </div>
                    <button
                        class="size-9 flex items-center justify-center rounded-xl bg-surface-darker border border-border-dark text-text-muted hover:text-text-main transition-all shadow-sm"
                        onclick={closeInspector}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <div class="grid grid-cols-3 gap-3">
                    <div
                        class="p-3 rounded-xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Confidence</span
                        >
                        <div class="flex items-center gap-2">
                            <span
                                class="text-xl font-mono font-bold {(
                                    selectedLog.confidence * 100
                                ).toFixed(0) === '100'
                                    ? 'text-emerald-500'
                                    : 'text-text-main'}"
                                >{(selectedLog.confidence * 100).toFixed(
                                    0,
                                )}%</span
                            >
                            <span
                                class="material-symbols-outlined text-sm {selectedLog.confidence >
                                0.9
                                    ? 'text-emerald-500 shadow-[0_0_10px_rgba(16,185,129,0.3)]'
                                    : 'text-amber-500'}"
                            >
                                {selectedLog.confidence > 0.9
                                    ? "verified_user"
                                    : "priority_high"}
                            </span>
                        </div>
                    </div>
                    <div
                        class="p-3 rounded-xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Duration</span
                        >
                        <span class="text-xl font-mono font-bold text-text-main"
                            >{selectedLog.duration}</span
                        >
                    </div>
                    <div
                        class="p-3 rounded-xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Royalty</span
                        >
                        <span
                            class="text-xl font-mono font-bold text-emerald-400"
                            >${selectedLog.royalty.toFixed(2)}</span
                        >
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="flex-1 overflow-y-auto p-8 space-y-8">
                <!-- Audio Verification Player -->
                <section class="space-y-4">
                    <div class="flex items-center justify-between">
                        <h3
                            class="text-xs font-bold text-text-main uppercase tracking-widest"
                        >
                            Audio Verification
                        </h3>
                        {#if isPlaying}
                            <div class="flex items-end gap-1 h-3">
                                <div
                                    class="w-1 bg-primary animate-pulse h-full"
                                ></div>
                                <div
                                    class="w-1 bg-primary animate-pulse delay-75 h-2/3"
                                ></div>
                                <div
                                    class="w-1 bg-primary animate-pulse delay-150 h-full"
                                ></div>
                            </div>
                        {/if}
                    </div>

                    <div
                        class="p-6 rounded-2xl bg-surface-darker border border-border-dark relative group overflow-hidden"
                    >
                        <div
                            class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"
                        ></div>

                        <div class="relative z-10 flex items-center gap-6">
                            <button
                                class="size-14 rounded-full bg-primary text-background-dark flex items-center justify-center shadow-lg shadow-primary/20 hover:scale-105 transition-all"
                                onclick={togglePlayback}
                            >
                                <span
                                    class="material-symbols-outlined text-3xl fill-current"
                                >
                                    {isPlaying ? "pause" : "play_arrow"}
                                </span>
                            </button>

                            <div class="flex-1 space-y-2">
                                <!-- Waveform Placeholder -->
                                <div
                                    class="h-12 flex items-center gap-0.5 px-1"
                                >
                                    {#each Array(40) as _, i}
                                        <div
                                            class="flex-1 rounded-full transition-all duration-300 {i <
                                            15
                                                ? 'bg-primary'
                                                : 'bg-surface-dark'}"
                                            style="height: {Math.random() * 80 +
                                                20}%"
                                        ></div>
                                    {/each}
                                </div>
                                <div
                                    class="flex justify-between text-[10px] font-mono text-text-muted"
                                >
                                    <span>0:45</span>
                                    <span>3:12</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Match Analysis -->
                <section class="space-y-4">
                    <h3
                        class="text-xs font-bold text-text-main uppercase tracking-widest"
                    >
                        Match Analysis
                    </h3>
                    <div
                        class="divide-y divide-border-dark/50 border border-border-dark rounded-xl overflow-hidden"
                    >
                        <div
                            class="p-4 bg-surface-darker flex items-center justify-between"
                        >
                            <div class="flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-text-muted"
                                    >fingerprint</span
                                >
                                <div class="flex flex-col">
                                    <span
                                        class="text-xs font-bold text-text-main uppercase tracking-wider"
                                        >Acoustic ID</span
                                    >
                                    <span
                                        class="text-[10px] font-mono text-text-muted"
                                        >{selectedLog.fingerprint_id}</span
                                    >
                                </div>
                            </div>
                            <span
                                class="material-symbols-outlined text-emerald-500 fill-current"
                                >check_circle</span
                            >
                        </div>
                        <div
                            class="p-4 bg-surface-darker flex items-center justify-between"
                        >
                            <div class="flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-text-muted"
                                    >broadcast_on_personal</span
                                >
                                <div class="flex flex-col">
                                    <span
                                        class="text-xs font-bold text-text-main uppercase tracking-wider"
                                        >Ingestion Method</span
                                    >
                                    <span
                                        class="text-[10px] text-text-muted uppercase"
                                        >IoT Gateway (OLAF-KE-001)</span
                                    >
                                </div>
                            </div>
                            <span
                                class="material-symbols-outlined text-emerald-500 fill-current"
                                >check_circle</span
                            >
                        </div>
                        <div
                            class="p-4 bg-surface-darker flex items-center justify-between"
                        >
                            <div class="flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-text-muted"
                                    >data_thresholding</span
                                >
                                <div class="flex flex-col">
                                    <span
                                        class="text-xs font-bold text-text-main uppercase tracking-wider"
                                        >Detection Window</span
                                    >
                                    <span
                                        class="text-[10px] text-text-muted uppercase"
                                        >3 seconds offset corrected</span
                                    >
                                </div>
                            </div>
                            <span
                                class="material-symbols-outlined text-amber-500"
                                >info</span
                            >
                        </div>
                    </div>
                </section>

                <!-- Calculation Flow -->
                <section class="space-y-4">
                    <h3
                        class="text-xs font-bold text-text-main uppercase tracking-widest"
                    >
                        Calculation Engine
                    </h3>
                    <div
                        class="p-6 rounded-2xl bg-surface-darker border border-border-dark space-y-4 relative"
                    >
                        <div class="flex justify-between items-center text-xs">
                            <span
                                class="text-text-secondary font-medium uppercase tracking-wider"
                                >Base Rate (per play)</span
                            >
                            <span class="text-text-main font-mono">$8.00</span>
                        </div>
                        <div class="flex justify-between items-center text-xs">
                            <span
                                class="text-text-secondary font-medium uppercase tracking-wider"
                                >Station Multiplier</span
                            >
                            <span class="text-text-main font-mono"
                                >x {selectedLog.multiplier.toFixed(2)}</span
                            >
                        </div>
                        <div
                            class="pt-4 border-t border-border-dark flex justify-between items-center"
                        >
                            <span
                                class="text-xs font-bold text-text-main uppercase tracking-widest"
                                >Calculated Royalty</span
                            >
                            <span
                                class="text-xl font-mono font-bold text-emerald-400"
                                >${selectedLog.royalty.toFixed(2)}</span
                            >
                        </div>
                    </div>
                </section>
            </div>

            <!-- Action Bar -->
            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 flex gap-3"
            >
                <button
                    class="flex-1 h-12 rounded-xl border border-border-dark bg-surface-dark text-text-main text-xs font-bold uppercase tracking-widest hover:bg-red-500/10 hover:text-red-500 hover:border-red-500/30 transition-all flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg">flag</span>
                    Flag Incident
                </button>
                <button
                    class="flex-1 h-12 rounded-xl btn-primary text-xs font-bold uppercase tracking-widest shadow-lg shadow-primary/20 flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg"
                        >verified</span
                    >
                    Confirm Match
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
    /* Hide scrollbar for Chrome, Safari and Opera */
    .scrollbar-none::-webkit-scrollbar {
        display: none;
    }

    /* Hide scrollbar for IE, Edge and Firefox */
    .scrollbar-none {
        -ms-overflow-style: none; /* IE and Edge */
        scrollbar-width: none; /* Firefox */
    }

    @keyframes pulse {
        0%,
        100% {
            transform: scaleY(1);
        }
        50% {
            transform: scaleY(0.7);
        }
    }

    .animate-pulse {
        animation: pulse 1s infinite ease-in-out;
    }

    .delay-75 {
        animation-delay: 0.15s;
    }
    .delay-150 {
        animation-delay: 0.3s;
    }
</style>
