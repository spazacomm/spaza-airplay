<script lang="ts">
    import type { PageData } from "./$types";
    import { fade, slide, fly } from "svelte/transition";

    let { data }: { data: PageData } = $props();

    // Mock Recordings Data
    const baseRecordings = [
        {
            id: "rec-1",
            title: "Sitya Loss (Radio Edit)",
            isrc: "UG-ABB-14-00123",
            version: "Radio Edit",
            duration: "3:45",
            releaseDate: "2014-05-12",
            workTitle: "Sitya Loss",
            label: "Big Talent Entertainment",
            status: "Live",
            cover: "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=100&h=100&fit=crop",
            artist: "Eddy Kenzo",
        },
        {
            id: "rec-2",
            title: "Midnight Train (Official Audio)",
            isrc: "KE-SOL-20-00045",
            version: "Original",
            duration: "4:12",
            releaseDate: "2020-06-18",
            workTitle: "Midnight Train",
            label: "Sol Generation",
            status: "Live",
            cover: "https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=100&h=100&fit=crop",
            artist: "Sauti Sol",
        },
        {
            id: "rec-3",
            title: "Jerusalema (Master KG Remix)",
            isrc: "ZA-MIC-19-00789",
            version: "Remix",
            duration: "5:20",
            releaseDate: "2019-11-29",
            workTitle: "Jerusalema",
            label: "Open Mic Productions",
            status: "Pending",
            cover: "https://images.unsplash.com/photo-1459749411177-042180ce673c?w=100&h=100&fit=crop",
            artist: "Master KG",
        },
    ];

    // Generate 500 recordings deterministically
    let recordings = $state(
        Array.from({ length: 500 }, (_, i) => {
            const base = baseRecordings[i % baseRecordings.length];
            return {
                ...base,
                id: `rec-${i}`,
                isrc: `CC-XXX-${24 + (i % 5)}-${(10000 + i).toString().slice(-5)}`,
                title: `${base.title} #${i + 1}`,
            };
        }),
    );

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
                    <div class="space-y-1">
                        <h1
                            class="text-2xl font-bold tracking-tight text-white leading-none"
                        >
                            Recordings
                        </h1>
                        <p class="text-xs text-text-secondary font-medium">
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
                                class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-9 pr-4 text-xs text-white placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/40 focus:border-primary/40 transition-all"
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
                                class="p-1.5 rounded-md text-text-muted hover:text-white hover:bg-surface-dark transition-all"
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
        <div class="flex-1">
            <div class="overflow-x-auto bg-surface-dark">
                <table class="w-full text-left border-collapse">
                    <thead
                        class="bg-surface-dark border-b border-border-dark shadow-sm sticky top-0 z-10"
                    >
                        <tr>
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >Recording Title</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >ISRC</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >Version</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >Label</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary text-right"
                                >Duration</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary text-center"
                                >Status</th
                            >
                            <th class="py-4 px-6 w-10"></th>
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
                                <td class="py-4 px-6">
                                    <div class="flex items-center gap-4">
                                        <div
                                            class="size-10 rounded-lg overflow-hidden bg-surface-dark flex items-center justify-center text-text-secondary shrink-0 shadow-md border border-border-dark"
                                        >
                                            {#if rec.cover}
                                                <img
                                                    src={rec.cover}
                                                    alt={rec.title}
                                                    class="w-full h-full object-cover"
                                                />
                                            {:else}
                                                <span
                                                    class="material-symbols-outlined text-xl"
                                                    >mic_external_on</span
                                                >
                                            {/if}
                                        </div>
                                        <div class="flex flex-col gap-0.5">
                                            <p
                                                class="font-bold text-sm text-white tracking-tight group-hover:text-primary transition-colors"
                                            >
                                                {rec.title}
                                            </p>
                                            <p
                                                class="text-[10px] text-text-muted"
                                            >
                                                Work: {rec.workTitle}
                                            </p>
                                        </div>
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
                                        class="size-8 flex items-center justify-center rounded-lg text-text-muted hover:text-white hover:bg-surface-dark transition-all"
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
                Showing <span class="text-white"
                    >{paginatedRecordings.length}</span
                >
                of <span class="text-white">{filteredRecordings.length}</span> recordings
            </p>
            <div class="flex items-center gap-6">
                <span
                    class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
                >
                    Page <span class="text-white">{currentPage}</span> / {Math.ceil(
                        filteredRecordings.length / itemsPerPage,
                    ) || 1}
                </span>
                <div class="flex gap-2">
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-white hover:bg-primary/5 transition-all disabled:opacity-20 disabled:cursor-not-allowed"
                        onclick={() =>
                            (currentPage = Math.max(1, currentPage - 1))}
                        disabled={currentPage === 1}
                    >
                        <span class="material-symbols-outlined text-xl"
                            >chevron_left</span
                        >
                    </button>
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-white hover:bg-primary/5 transition-all disabled:opacity-20 disabled:cursor-not-allowed"
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
            class="fixed inset-0 bg-black/40 z-40 backdrop-blur-[2px]"
            onclick={closeDetails}
        ></div>
        <aside
            class="fixed right-0 top-0 bottom-0 w-full max-w-[450px] border-l border-border-dark bg-surface-dark flex flex-col shadow-2xl z-50 overflow-hidden"
            transition:fly={{ x: 450, duration: 300, opacity: 1 }}
        >
            <div
                class="p-6 border-b border-border-dark flex items-center justify-between bg-surface-dark sticky top-0 z-10"
            >
                <div>
                    <h2 class="text-xl font-bold text-white tracking-tight">
                        Recording Details
                    </h2>
                    <p
                        class="text-[10px] text-text-muted uppercase tracking-widest mt-1 font-bold"
                    >
                        Metadata & Fingerprint
                    </p>
                </div>
                <button
                    class="size-8 flex items-center justify-center rounded-full hover:bg-surface-darker text-text-secondary hover:text-white transition-colors"
                    onclick={closeDetails}
                >
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
                            class="text-2xl font-bold text-white tracking-tight leading-relaxed"
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
                                class="text-sm font-mono text-white tracking-tighter"
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
                                class="text-sm font-semibold text-white tracking-tight uppercase"
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
                                class="text-sm font-bold text-white hover:text-primary transition-colors cursor-pointer"
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
                                class="text-sm font-mono text-white tracking-tighter"
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
                                    class="text-xs font-bold text-white uppercase tracking-wider"
                                    >{selectedRecording.label}</span
                                >
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-xs text-text-muted"
                                    >Release Date</span
                                >
                                <span class="text-xs font-bold text-white"
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
                    <h2 class="text-xl font-bold text-white tracking-tight">
                        Register New Recording
                    </h2>
                    <p class="text-xs text-text-secondary mt-1">
                        Link a master recording to a composition.
                    </p>
                </div>
                <button
                    class="size-8 flex items-center justify-center rounded-full hover:bg-surface-darker text-text-secondary hover:text-white transition-colors"
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
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: white;
        font-size: 0.875rem;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: rgba(16, 185, 129, 0.5);
        box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.1);
    }
    .select {
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: white;
        font-size: 0.875rem;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 1rem center;
        background-size: 1rem;
    }
</style>
