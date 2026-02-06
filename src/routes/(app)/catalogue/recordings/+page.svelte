<script lang="ts">
    import type { PageData } from "./$types";
    import { fade, slide, fly } from "svelte/transition";

    let { data }: { data: PageData } = $props();

    // recordings from Supabase
    let recordings = $state(data.recordings || []);

    $effect(() => {
        if (data.recordings) {
            recordings = data.recordings;
        }
    });

    // Filter & Search State
    let searchQuery = $state("");
    let filterStatus = $state("All");
    let filterVersion = $state("All");
    let currentPage = $state(1);
    const itemsPerPage = 25;

    const filteredRecordings = $derived(
        recordings.filter((r) => {
            const matchesSearch =
                r.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                r.isrc.toLowerCase().includes(searchQuery.toLowerCase()) ||
                r.workTitle.toLowerCase().includes(searchQuery.toLowerCase());

            const matchesStatus =
                filterStatus === "All" || r.status === filterStatus;
            const matchesVersion =
                filterVersion === "All" || r.version === filterVersion;

            return matchesSearch && matchesStatus && matchesVersion;
        }),
    );

    const paginatedRecordings = $derived(
        filteredRecordings.slice(
            (currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage,
        ),
    );

    let statuses = ["All", "Live", "Pending", "Archived"];
    let versions = ["All", "Original", "Radio Edit", "Remix", "Live"];

    function resetFilters() {
        searchQuery = "";
        filterStatus = "All";
        filterVersion = "All";
        currentPage = 1;
    }

    $effect(() => {
        // Reset to page 1 on filter change
        if (searchQuery || filterStatus !== "All" || filterVersion !== "All") {
            currentPage = 1;
        }
    });

    // Interaction State
    let selectedRecId = $state("");
    let isCreateOffcanvasOpen = $state(false);

    const selectedRecording = $derived(
        recordings.find((r) => r.id === selectedRecId),
    );

    function openDetails(id: string) {
        selectedRecId = id;
    }

    function closeDetails() {
        selectedRecId = "";
    }

    // Create Logic
    let newRec = $state({
        title: "",
        workTitle: "",
        isrc: "",
        version: "Original",
        label: "",
        releaseDate: new Date().toISOString().split("T")[0],
    });

    function handleCreateRecording() {
        const id = `rec-${Date.now()}`;
        recordings = [
            {
                ...newRec,
                id,
                status: "Pending",
                duration: "0:00",
                cover: "",
                artist: "Unknown",
            } as any,
            ...recordings,
        ];

        isCreateOffcanvasOpen = false;
        selectedRecId = id;

        // Reset form
        newRec = {
            title: "",
            workTitle: "",
            isrc: "",
            version: "Original",
            label: "",
            releaseDate: new Date().toISOString().split("T")[0],
        };
    }
</script>

<svelte:head>
    <title>Recordings | Spaza Airplay</title>
</svelte:head>

<div class="flex flex-col min-h-full w-full max-w-full relative">
    <main class="flex-1 flex flex-col min-w-0 bg-surface-darker">
        <!-- Page Header -->
        <div
            class="bg-surface-dark border-b border-border-dark shadow-sm sticky top-0 z-30"
        >
            <!-- Title Section -->
            <div class="px-6 py-5 border-b border-border-dark/50">
                <div class="max-w-[1600px] mx-auto">
                    <nav
                        class="flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest text-text-muted mb-3"
                    >
                        <a
                            href="/dashboard"
                            class="hover:text-primary transition-colors">Home</a
                        >
                        <span class="text-border-dark">/</span>
                        <span class="text-text-secondary">Catalog</span>
                    </nav>
                    <div>
                        <h1
                            class="text-3xl font-bold tracking-tight text-text-main"
                        >
                            Recordings
                        </h1>
                        <p class="text-text-secondary mt-1">
                            Manage master recordings, ISRCs, and fingerprint
                            status.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Toolbar Section -->
            <div class="px-6 py-2 bg-surface-darker/50 backdrop-blur-sm">
                <div
                    class="flex flex-col md:flex-row items-center justify-between gap-4"
                >
                    <div
                        class="flex flex-col md:flex-row gap-2 items-center flex-1 w-full"
                    >
                        <!-- Search -->
                        <div class="relative flex-1 w-full max-w-md">
                            <span
                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-base"
                                >search</span
                            >
                            <input
                                type="text"
                                placeholder="Search recordings..."
                                class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-9 pr-4 text-xs text-text-main placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/40 focus:border-primary/40 transition-all"
                                bind:value={searchQuery}
                            />
                        </div>

                        <div class="flex items-center gap-2 w-full md:w-auto">
                            <!-- Version Select -->
                            <div class="relative min-w-[130px]">
                                <select
                                    class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-3 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary hover:border-border-muted transition-colors appearance-none cursor-pointer"
                                    bind:value={filterVersion}
                                >
                                    {#each versions as v}
                                        <option value={v}
                                            >{v === "All"
                                                ? "All Versions"
                                                : v}</option
                                        >
                                    {/each}
                                </select>
                                <span
                                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-base text-text-muted pointer-events-none"
                                    >expand_more</span
                                >
                            </div>

                            <!-- Status Select -->
                            <div class="relative min-w-[130px]">
                                <select
                                    class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-3 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary hover:border-border-muted transition-colors appearance-none cursor-pointer"
                                    bind:value={filterStatus}
                                >
                                    {#each statuses as s}
                                        <option value={s}
                                            >{s === "All"
                                                ? "All Status"
                                                : s}</option
                                        >
                                    {/each}
                                </select>
                                <span
                                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-base text-text-muted pointer-events-none"
                                    >expand_more</span
                                >
                            </div>

                            <button
                                class="p-1.5 rounded-md text-text-muted hover:text-text-main hover:bg-surface-dark transition-all"
                                onclick={resetFilters}
                                title="Reset Filters"
                            >
                                <span
                                    class="material-symbols-outlined text-base"
                                    >refresh</span
                                >
                            </button>
                        </div>
                    </div>

                    <button
                        class="btn-primary py-1.5 px-4 text-[10px] font-bold uppercase tracking-wider flex items-center gap-2 shadow-lg shadow-primary/5 w-full md:w-auto justify-center"
                        onclick={() => (isCreateOffcanvasOpen = true)}
                    >
                        <span class="material-symbols-outlined text-base"
                            >add</span
                        >
                        Register Recording
                    </button>
                </div>
            </div>
        </div>

        <!-- Table Area -->
        <div class="flex-1 pb-6">
            <div
                class="overflow-auto max-h-[calc(100vh-280px)] bg-white border-t border-slate-200"
            >
                <table class="table-enterprise">
                    <thead>
                        <tr>
                            <th>Recording Title</th>
                            <th>ISRC</th>
                            <th>Version</th>
                            <th>Label</th>
                            <th class="th-numeric">Duration</th>
                            <th class="text-center">Status</th>
                            <th class="w-10"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-dark/50">
                        {#each paginatedRecordings as rec (rec.id)}
                            <tr
                                class="table-row group relative cursor-pointer"
                                class:table-row-active={selectedRecId ===
                                    rec.id}
                                onclick={() => openDetails(rec.id)}
                            >
                                {#if selectedRecId === rec.id}
                                    <td
                                        class="absolute left-0 top-0 bottom-0 w-1 bg-primary"
                                    ></td>
                                {/if}
                                <td class="py-3 px-4">
                                    <div class="flex flex-col gap-0.5">
                                        <p
                                            class="font-semibold text-sm text-text-primary tracking-tight group-hover:text-primary transition-colors"
                                        >
                                            {rec.title}
                                        </p>
                                        <p class="text-[11px] text-text-muted">
                                            {rec.workTitle}
                                        </p>
                                    </div>
                                </td>
                                <td
                                    class="py-4 px-6 text-xs font-mono text-text-secondary tracking-tighter"
                                    >{rec.isrc}</td
                                >
                                <td
                                    class="py-4 px-6 text-[11px] font-semibold text-text-secondary uppercase tracking-wider"
                                    >{rec.version}</td
                                >
                                <td
                                    class="py-4 px-6 text-xs text-text-secondary font-medium"
                                    >{rec.label}</td
                                >
                                <td
                                    class="py-4 px-6 text-right text-xs font-mono text-text-muted"
                                    >{rec.duration}</td
                                >
                                <td class="py-4 px-6 text-center">
                                    <span
                                        class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-widest {rec.status ===
                                        'Live'
                                            ? 'bg-emerald-500/10 text-emerald-400'
                                            : 'bg-amber-500/10 text-amber-400'}"
                                    >
                                        {rec.status}
                                    </span>
                                </td>
                                <td class="py-4 px-6 text-right">
                                    <button
                                        class="size-8 flex items-center justify-center rounded-lg text-text-muted hover:text-text-main hover:bg-surface-dark transition-all"
                                    >
                                        <span
                                            class="material-symbols-outlined text-lg"
                                            >more_vert</span
                                        >
                                    </button>
                                </td>
                            </tr>
                        {:else}
                            <tr>
                                <td colspan="7" class="py-20 text-center">
                                    <div
                                        class="flex flex-col items-center gap-3 text-text-muted"
                                    >
                                        <span
                                            class="material-symbols-outlined text-5xl opacity-20"
                                            >search_off</span
                                        >
                                        <p class="text-sm font-medium">
                                            No recordings found matching your
                                            filters
                                        </p>
                                        <button
                                            class="text-xs text-primary hover:underline font-bold uppercase tracking-widest"
                                            onclick={resetFilters}
                                            >Clear all filters</button
                                        >
                                    </div>
                                </td>
                            </tr>
                        {/each}
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination Bar -->
        <div
            class="sticky bottom-0 bg-surface-darker/95 backdrop-blur-md border-t border-border-dark px-6 py-4 flex items-center justify-between z-20 shadow-[0_-10px_30px_rgba(0,0,0,0.3)]"
        >
            <p
                class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
            >
                Showing <span class="text-text-main"
                    >{paginatedRecordings.length}</span
                >
                of
                <span class="text-text-main">{filteredRecordings.length}</span> recordings
            </p>
            <div class="flex items-center gap-6">
                <span
                    class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
                >
                    Page <span class="text-text-main">{currentPage}</span> / {Math.ceil(
                        filteredRecordings.length / itemsPerPage,
                    ) || 1}
                </span>
                <div class="flex gap-2">
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-text-main hover:bg-primary/5 transition-all disabled:opacity-20 disabled:cursor-not-allowed"
                        onclick={() =>
                            (currentPage = Math.max(1, currentPage - 1))}
                        disabled={currentPage === 1}
                    >
                        <span class="material-symbols-outlined text-xl"
                            >chevron_left</span
                        >
                    </button>
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-text-main hover:bg-primary/5 transition-all disabled:opacity-20 disabled:cursor-not-allowed"
                        onclick={() =>
                            (currentPage = Math.min(
                                Math.ceil(
                                    filteredRecordings.length / itemsPerPage,
                                ),
                                currentPage + 1,
                            ))}
                        disabled={currentPage ===
                            Math.ceil(
                                filteredRecordings.length / itemsPerPage,
                            ) || filteredRecordings.length === 0}
                    >
                        <span class="material-symbols-outlined text-xl"
                            >chevron_right</span
                        >
                    </button>
                </div>
            </div>
        </div>
    </main>

    <!-- Detail View Offcanvas -->
    {#if selectedRecording}
        <div
            class="offcanvas-backdrop"
            role="button"
            tabindex="0"
            aria-label="Close panel"
            onclick={closeDetails}
            onkeydown={(e) => e.key === "Escape" && closeDetails()}
        ></div>
        <aside
            class="offcanvas-panel"
            transition:fly={{ x: 480, duration: 300, opacity: 1 }}
        >
            <div class="offcanvas-header">
                <div class="flex items-center gap-3">
                    <div class="offcanvas-header-icon">
                        <span class="material-symbols-outlined"
                            >mic_external_on</span
                        >
                    </div>
                    <div>
                        <h2 class="offcanvas-title">Recording Details</h2>
                        <p class="offcanvas-subtitle">Metadata & Fingerprint</p>
                    </div>
                </div>
                <button class="offcanvas-close" onclick={closeDetails}>
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto">
                <div
                    class="p-8 flex flex-col items-center border-b border-border-dark/50 bg-gradient-to-b from-surface-darker to-surface-dark"
                >
                    <div
                        class="size-48 rounded-2xl overflow-hidden shadow-2xl border-4 border-surface-dark relative group"
                    >
                        {#if selectedRecording.cover}
                            <img
                                src={selectedRecording.cover}
                                alt={selectedRecording.title}
                                class="w-full h-full object-cover"
                            />
                        {:else}
                            <div
                                class="w-full h-full flex items-center justify-center bg-surface-darker"
                            >
                                <span
                                    class="material-symbols-outlined text-6xl text-text-muted opacity-30"
                                    >mic_external_on</span
                                >
                            </div>
                        {/if}
                    </div>
                    <div class="mt-6 text-center">
                        <h3
                            class="text-2xl font-bold text-text-main tracking-tight leading-relaxed"
                        >
                            {selectedRecording.title}
                        </h3>
                        <p
                            class="text-primary font-bold text-sm tracking-wide uppercase mt-1"
                        >
                            {selectedRecording.artist || "Unknown Artist"}
                        </p>
                    </div>
                </div>

                <div class="p-8 space-y-8">
                    <div class="grid grid-cols-2 gap-6">
                        <div class="space-y-1">
                            <p
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                            >
                                ISRC
                            </p>
                            <p
                                class="text-sm font-mono text-text-main tracking-tighter"
                            >
                                {selectedRecording.isrc}
                            </p>
                        </div>
                        <div class="space-y-1">
                            <p
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                            >
                                Version
                            </p>
                            <p
                                class="text-sm font-semibold text-text-main tracking-tight uppercase"
                            >
                                {selectedRecording.version}
                            </p>
                        </div>
                        <div class="space-y-1">
                            <p
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                            >
                                Base Work
                            </p>
                            <p
                                class="text-sm font-bold text-text-main hover:text-primary transition-colors cursor-pointer"
                            >
                                {selectedRecording.workTitle}
                            </p>
                        </div>
                        <div class="space-y-1">
                            <p
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                            >
                                Duration
                            </p>
                            <p
                                class="text-sm font-mono text-text-main tracking-tighter"
                            >
                                {selectedRecording.duration}
                            </p>
                        </div>
                    </div>

                    <div class="space-y-4 pt-8 border-t border-border-dark/50">
                        <h4
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >
                            Distribution
                        </h4>
                        <div
                            class="bg-surface-darker rounded-xl border border-border-dark p-4 space-y-4"
                        >
                            <div class="flex items-center justify-between">
                                <span class="text-xs text-text-muted"
                                    >Label</span
                                >
                                <span
                                    class="text-xs font-bold text-text-main uppercase tracking-wider"
                                    >{selectedRecording.label}</span
                                >
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-xs text-text-muted"
                                    >Release Date</span
                                >
                                <span class="text-xs font-bold text-text-main"
                                    >{selectedRecording.releaseDate}</span
                                >
                            </div>
                        </div>
                    </div>

                    <div class="space-y-3">
                        <h4
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >
                            Olaf Fingerprint
                        </h4>
                        <div
                            class="flex items-center gap-3 p-3 bg-emerald-500/5 border border-emerald-500/20 rounded-lg"
                        >
                            <div
                                class="size-8 rounded bg-emerald-500/20 flex items-center justify-center text-emerald-400"
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >check_circle</span
                                >
                            </div>
                            <div>
                                <p
                                    class="text-[11px] font-bold text-emerald-400 uppercase tracking-widest"
                                >
                                    Active & Monitored
                                </p>
                                <p class="text-[10px] text-text-muted mt-0.5">
                                    Hash: 87f2e1a...z9x (Jenkins)
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </aside>
    {/if}

    <!-- Create Recording Offcanvas -->
    {#if isCreateOffcanvasOpen}
        <div
            class="fixed inset-0 bg-black/60 z-40 backdrop-blur-sm"
            onclick={() => (isCreateOffcanvasOpen = false)}
        ></div>
        <aside
            class="fixed right-0 top-0 bottom-0 w-full max-w-[500px] border-l border-border-dark bg-surface-dark flex flex-col shadow-2xl z-50 transform"
            transition:fly={{ x: 500, duration: 400, opacity: 1 }}
        >
            <div
                class="p-6 border-b border-border-dark flex items-center justify-between bg-surface-dark sticky top-0 z-10"
            >
                <div>
                    <h2 class="text-xl font-bold text-text-main tracking-tight">
                        Register New Recording
                    </h2>
                    <p class="text-xs text-text-secondary mt-1">
                        Link a master recording to a composition.
                    </p>
                </div>
                <button
                    class="size-8 flex items-center justify-center rounded-full hover:bg-surface-darker text-text-secondary hover:text-text-main transition-colors"
                    onclick={() => (isCreateOffcanvasOpen = false)}
                >
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto p-6 space-y-8">
                <div class="space-y-4">
                    <div class="space-y-2">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            for="rec-title">Recording Title</label
                        >
                        <input
                            id="rec-title"
                            type="text"
                            placeholder="e.g., Sitya Loss (Radio Edit)"
                            class="input w-full"
                            bind:value={newRec.title}
                        />
                    </div>
                    <div class="space-y-2">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            for="work-link">Link to Composition</label
                        >
                        <input
                            id="work-link"
                            type="text"
                            placeholder="Search works..."
                            class="input w-full"
                            bind:value={newRec.workTitle}
                        />
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="isrc">ISRC</label
                            >
                            <input
                                id="isrc"
                                type="text"
                                placeholder="CC-XXX-YY-NNNNN"
                                class="input w-full font-mono text-xs"
                                bind:value={newRec.isrc}
                            />
                        </div>
                        <div class="space-y-2">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="version">Version</label
                            >
                            <select
                                id="version"
                                class="select w-full"
                                bind:value={newRec.version}
                            >
                                {#each versions.filter((v) => v !== "All") as v}
                                    <option value={v}>{v}</option>
                                {/each}
                            </select>
                        </div>
                    </div>
                    <div class="space-y-2">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            for="label">Label / Owner</label
                        >
                        <input
                            id="label"
                            type="text"
                            placeholder="Enter label name..."
                            class="input w-full"
                            bind:value={newRec.label}
                        />
                    </div>
                </div>
            </div>

            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 backdrop-blur-md"
            >
                <button
                    class="w-full btn btn-primary py-4 font-bold uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl shadow-primary/20"
                    disabled={!newRec.title || !newRec.workTitle}
                    onclick={handleCreateRecording}
                >
                    <span class="material-symbols-outlined">save</span>
                    Register Recording
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
    .table-row {
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .table-row:hover {
        background: rgba(255, 255, 255, 0.02);
    }
    .table-row-active {
        background: rgba(16, 185, 129, 0.05) !important;
    }
    .input {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: #10b981;
        box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.1);
    }
    .select {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 1rem center;
        background-size: 1rem;
    }
</style>
