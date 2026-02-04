<script lang="ts">
    import type { PageData } from "./$types";
    import { fade, slide, fly } from "svelte/transition";

    let { data }: { data: PageData } = $props();

    // Generate more mock data to simulate "thousands"
    const baseWorks = [
        {
            id: "w1",
            title: "Sitya Loss",
            iswc: "T-123.456.789-C",
            contributors: [
                { name: "Eddy Kenzo", role: "Composer" },
                { name: "Big Talent", role: "Publisher" },
                { name: "Ssemivumbi", role: "Arranger" },
            ],
            metadata: {
                genre: "Afrobeats",
                mood: "Energetic",
                bpm: 125,
                tempo: "Fast",
            },
            recordings: [
                {
                    id: "r1",
                    title: "Sitya Loss (Radio Edit)",
                    isrc: "UG-ABC-14-00001",
                    version: "Radio Edit",
                    duration: "3:45",
                    releaseDate: "2014-05-12",
                    fingerprintId: "HASH_9912",
                    status: "Live",
                    cover: "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=300&h=300&fit=crop",
                },
            ],
            work_rights: [
                { name: "Eddy Kenzo", role: "Composer", share: 50 },
                { name: "Big Talent", role: "Publisher", share: 50 },
            ],
            recording_rights: [
                { name: "Eddy Kenzo", role: "Performer", share: 40 },
                { name: "Big Talent", role: "Label", share: 60 },
            ],
            plays: "1.2M",
            earnings: "$12,450",
            status: "Live",
        },
        {
            id: "w2",
            title: "Midnight Train",
            iswc: "T-987.654.321-K",
            contributors: [
                { name: "Sauti Sol", role: "Composer" },
                { name: "Savara", role: "Lyricist" },
                { name: "Chimano", role: "Vocalist" },
                { name: "Polycarp", role: "Guitarist" },
            ],
            metadata: {
                genre: "Afro-Pop",
                mood: "Chilled",
                bpm: 98,
                tempo: "Mid",
            },
            recordings: [
                {
                    id: "r3",
                    title: "Midnight Train (Original)",
                    isrc: "KE-XYZ-20-00441",
                    version: "Original",
                    duration: "4:02",
                    releaseDate: "2020-06-05",
                    fingerprintId: "HASH_1122",
                    status: "Live",
                    cover: "https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=300&h=300&fit=crop",
                },
            ],
            work_rights: [
                { name: "Sauti Sol", role: "Composer", share: 70 },
                { name: "Universal Music", role: "Publisher", share: 30 },
            ],
            recording_rights: [
                { name: "Sauti Sol", role: "Main Artist", share: 50 },
                { name: "Universal Music Africa", role: "Label", share: 50 },
            ],
            plays: "892K",
            earnings: "$9,120",
            status: "Live",
        },
        {
            id: "w3",
            title: "Jerusalema",
            iswc: "T-456.789.012-S",
            contributors: [
                { name: "Master KG", role: "Composer" },
                { name: "Nomcebo Zikode", role: "Lyricist" },
            ],
            metadata: {
                genre: "Amapiano",
                mood: "Uplifting",
                bpm: 112,
                tempo: "Fast",
            },
            recordings: [
                {
                    id: "r4",
                    title: "Jerusalema (Original)",
                    isrc: "ZA-P84-19-00001",
                    version: "Original",
                    duration: "4:08",
                    releaseDate: "2019-11-29",
                    fingerprintId: "HASH_4433",
                    status: "Live",
                    cover: "https://images.unsplash.com/photo-1514525253361-bee8a187499b?w=300&h=300&fit=crop",
                },
            ],
            work_rights: [
                { name: "Master KG", role: "Composer", share: 50 },
                { name: "Nomcebo", role: "Lyricist", share: 50 },
            ],
            recording_rights: [
                { name: "Open Mic Productions", role: "Label", share: 100 },
            ],
            plays: "45.1M",
            earnings: "$152,400",
            status: "Pending",
        },
    ];

    // Generate 1000 items
    let works = $state(
        Array.from({ length: 1000 }, (_, i) => {
            const base = baseWorks[i % baseWorks.length];
            return {
                ...base,
                id: `w-${i}`,
                title: `${base.title} ${i > 2 ? `(Copy ${i})` : ""}`,
                iswc: `T-${100 + i}.000.${800 + i}-X`,
                plays: (Math.random() * 10).toFixed(1) + "M",
                earnings: "$" + (Math.random() * 10000).toFixed(0),
                status:
                    i % 10 === 0
                        ? "Pending"
                        : i % 25 === 0
                          ? "Takedown"
                          : "Live",
            };
        }),
    );

    let selectedWorkId = $state("");
    let isOffcanvasOpen = $state(false);
    let isCreateOffcanvasOpen = $state(false);

    // Form state for new work
    let newWork = $state({
        title: "",
        iswc: "",
        genre: "Afrobeats",
        contributors: [{ name: "", role: "Composer" }],
    });

    function addContributor() {
        newWork.contributors.push({ name: "", role: "Composer" });
    }

    function removeContributor(index: number) {
        newWork.contributors = newWork.contributors.filter(
            (_, i) => i !== index,
        );
    }

    function handleCreateWork() {
        const id = `w-new-${Date.now()}`;
        const workToAdd = {
            id,
            title: newWork.title,
            iswc: newWork.iswc || `T-NEW.${Math.floor(Math.random() * 999)}`,
            contributors: [...newWork.contributors],
            metadata: {
                genre: newWork.genre,
                mood: "New",
                bpm: 120,
                tempo: "Mid",
            },
            recordings: [],
            work_rights: [],
            recording_rights: [],
            plays: "0",
            earnings: "$0",
            status: "Pending",
        };

        works.unshift(workToAdd);
        isCreateOffcanvasOpen = false;

        // Reset form
        newWork = {
            title: "",
            iswc: "",
            genre: "Afrobeats",
            contributors: [{ name: "", role: "Composer" }],
        };

        // Optionally select the new work
        openDetails(id);
    }

    // Search and Filter State
    let searchQuery = $state("");
    let filterGenre = $state("All");
    let filterStatus = $state("All");
    let currentPage = $state(1);
    const itemsPerPage = 50;

    const filteredWorks = $derived(
        works.filter((w) => {
            const matchesSearch =
                w.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                w.iswc.toLowerCase().includes(searchQuery.toLowerCase()) ||
                w.contributors.some((c) =>
                    c.name.toLowerCase().includes(searchQuery.toLowerCase()),
                );

            const matchesGenre =
                filterGenre === "All" || w.metadata.genre === filterGenre;
            const matchesStatus =
                filterStatus === "All" || w.status === filterStatus;

            return matchesSearch && matchesGenre && matchesStatus;
        }),
    );

    const paginatedWorks = $derived(
        filteredWorks.slice(
            (currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage,
        ),
    );

    const selectedWork = $derived(
        works.find((w) => w.id === selectedWorkId) || works[0],
    );

    function openDetails(workId: string) {
        selectedWorkId = workId;
        isOffcanvasOpen = true;
    }

    // Filter Helpers
    let genres = ["All", "Afrobeats", "Afro-Pop", "Amapiano", "Reggae"];
    let statuses = ["All", "Live", "Pending", "Takedown"];

    // Tabs for offcanvas
    let activeTab = $state("overview");

    function resetFilters() {
        searchQuery = "";
        filterGenre = "All";
        filterStatus = "All";
        currentPage = 1;
    }

    $effect(() => {
        // Reset page when filters change
        searchQuery;
        filterGenre;
        filterStatus;
        currentPage = 1;
    });
</script>

<svelte:head>
    <title>Catalog | Spaza Airplay</title>
</svelte:head>

<div class="flex flex-col min-h-full w-full max-w-full">
    <!-- Middle: Songs Table -->
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
                            Catalog
                        </h1>
                        <p class="text-xs text-text-secondary font-medium">
                            Manage and organize your musical compositions and
                            rights splits with a composition-first approach.
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
                                placeholder="Search catalog..."
                                class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-9 pr-4 text-xs text-white placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/40 focus:border-primary/40 transition-all"
                                bind:value={searchQuery}
                            />
                        </div>

                        <div class="flex items-center gap-2 w-full md:w-auto">
                            <!-- Genre Select -->
                            <div class="relative min-w-[130px]">
                                <select
                                    class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-3 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary hover:border-border-muted transition-colors appearance-none cursor-pointer"
                                    bind:value={filterGenre}
                                >
                                    {#each genres as g}
                                        <option value={g}
                                            >{g === "All"
                                                ? "All Genres"
                                                : g}</option
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
                        Register Work
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
                                >Work Title</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >ISWC</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >Contributors</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary text-right"
                                >Total Plays</th
                            >
                            <th
                                class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary text-right"
                                >Earnings</th
                            >
                            <th class="py-4 px-6 w-10"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-dark/50">
                        {#each paginatedWorks as work (work.id)}
                            <tr
                                class="table-row group relative cursor-pointer"
                                class:table-row-active={selectedWorkId ===
                                    work.id}
                                onclick={() => openDetails(work.id)}
                            >
                                {#if selectedWorkId === work.id}
                                    <td
                                        class="absolute left-0 top-0 bottom-0 w-1 bg-primary"
                                    ></td>
                                {/if}
                                <td class="py-5 px-8">
                                    <div class="flex items-center gap-4">
                                        <div
                                            class="size-12 rounded-xl overflow-hidden bg-surface-dark flex items-center justify-center text-text-secondary shrink-0 shadow-lg border border-border-dark"
                                        >
                                            {#if work.recordings?.[0]?.cover}
                                                <img
                                                    src={work.recordings[0]
                                                        .cover}
                                                    alt={work.title}
                                                    class="w-full h-full object-cover"
                                                />
                                            {:else}
                                                <span
                                                    class="material-symbols-outlined text-2xl"
                                                    >sketch</span
                                                >
                                            {/if}
                                        </div>
                                        <div class="flex flex-col gap-0.5">
                                            <p
                                                class="font-bold text-base text-white tracking-tight group-hover:text-primary transition-colors"
                                            >
                                                {work.title}
                                            </p>
                                            <div
                                                class="flex flex-wrap gap-x-1 gap-y-0.5 max-w-[200px]"
                                            >
                                                {#each work.contributors.slice(0, 3) as c, i}
                                                    <span
                                                        class="text-[11px] font-medium text-text-secondary"
                                                    >
                                                        {c.name}{i <
                                                        Math.min(
                                                            2,
                                                            work.contributors
                                                                .length - 1,
                                                        )
                                                            ? ","
                                                            : ""}
                                                    </span>
                                                {/each}
                                                {#if work.contributors.length > 3}
                                                    <span
                                                        class="text-[11px] font-bold text-primary/80"
                                                        >+{work.contributors
                                                            .length - 3} more</span
                                                    >
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td
                                    class="py-5 px-6 text-xs text-text-secondary font-mono tracking-wider"
                                    >{work.iswc}</td
                                >
                                <td class="py-5 px-6 text-sm">
                                    <div
                                        class="flex flex-wrap gap-1.5 max-w-[220px]"
                                    >
                                        {#each work.contributors as c}
                                            <span
                                                class="px-2 py-0.5 rounded-lg bg-surface-dark border border-border-dark/50 text-[10px] font-bold uppercase tracking-tight text-text-secondary whitespace-nowrap group-hover:border-primary/30 transition-all"
                                            >
                                                {c.name}
                                            </span>
                                        {/each}
                                    </div>
                                </td>
                                <td
                                    class="py-5 px-6 text-right text-base font-bold tabular-nums text-white"
                                    >{work.plays}</td
                                >
                                <td
                                    class="py-5 px-6 text-right text-base font-bold tabular-nums text-primary drop-shadow-[0_0_8px_rgba(20,184,166,0.3)]"
                                    >{work.earnings}</td
                                >
                                <td class="py-5 px-6 text-center">
                                    <button
                                        class="size-8 flex items-center justify-center rounded-full hover:bg-surface-dark text-text-muted hover:text-white opacity-0 group-hover:opacity-100 transition-all"
                                    >
                                        <span
                                            class="material-symbols-outlined text-lg"
                                            >more_horiz</span
                                        >
                                    </button>
                                </td>
                            </tr>
                        {:else}
                            <tr>
                                <td colspan="6" class="py-24 text-center">
                                    <div
                                        class="flex flex-col items-center gap-4 max-w-xs mx-auto"
                                        in:fade
                                    >
                                        <div
                                            class="size-16 rounded-full bg-surface-dark flex items-center justify-center text-text-muted mb-2 shadow-inner"
                                        >
                                            <span
                                                class="material-symbols-outlined text-4xl"
                                                >search_off</span
                                            >
                                        </div>
                                        <h3
                                            class="text-lg font-bold text-white"
                                        >
                                            No works found
                                        </h3>
                                        <p
                                            class="text-sm text-text-secondary leading-relaxed"
                                        >
                                            We couldn't find any compositions
                                            matching your current search or
                                            filters. Try adjusting your
                                            criteria.
                                        </p>
                                        <button
                                            class="mt-4 text-xs font-bold uppercase tracking-widest text-primary hover:underline underline-offset-4 flex items-center gap-2"
                                            onclick={resetFilters}
                                        >
                                            <span
                                                class="material-symbols-outlined text-sm"
                                                >filter_alt_off</span
                                            >
                                            Clear all filters
                                        </button>
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
                Showing <span class="text-white">{paginatedWorks.length}</span>
                of <span class="text-white">{filteredWorks.length}</span> works
            </p>
            <div class="flex items-center gap-6">
                <span
                    class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
                >
                    Page <span class="text-white">{currentPage}</span> / {Math.ceil(
                        filteredWorks.length / itemsPerPage,
                    )}
                </span>
                <div class="flex gap-2">
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-white hover:border-primary/50 hover:bg-primary/5 transition-all disabled:opacity-20 disabled:cursor-not-allowed"
                        onclick={() =>
                            (currentPage = Math.max(1, currentPage - 1))}
                        disabled={currentPage === 1}
                    >
                        <span class="material-symbols-outlined text-xl"
                            >chevron_left</span
                        >
                    </button>
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-white hover:border-primary/50 hover:bg-primary/5 transition-all disabled:opacity-20 disabled:cursor-not-allowed"
                        onclick={() =>
                            (currentPage = Math.min(
                                Math.ceil(filteredWorks.length / itemsPerPage),
                                currentPage + 1,
                            ))}
                        disabled={currentPage ===
                            Math.ceil(filteredWorks.length / itemsPerPage)}
                    >
                        <span class="material-symbols-outlined text-xl"
                            >chevron_right</span
                        >
                    </button>
                </div>
            </div>
        </div>
    </main>

    <!-- Right Offcanvas / Inspector -->
    {#if isOffcanvasOpen}
        <div
            class="fixed inset-0 bg-black/60 z-40 backdrop-blur-sm lg:hidden"
            role="button"
            tabindex="0"
            aria-label="Close details"
            onclick={() => (isOffcanvasOpen = false)}
            onkeydown={(e) => e.key === "Escape" && (isOffcanvasOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>

        <aside
            class="fixed right-0 top-0 bottom-0 w-full max-w-[500px] border-l border-border-dark bg-surface-dark flex flex-col overflow-y-auto shadow-2xl z-50 transform"
            transition:fly={{ x: 500, duration: 400, opacity: 1 }}
        >
            <div class="flex flex-col h-full">
                <!-- Header -->
                <div
                    class="p-6 border-b border-border-dark sticky top-0 bg-surface-dark z-10"
                >
                    <div class="flex items-center justify-between mb-6">
                        <span
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                            >Work Details</span
                        >
                        <button
                            class="size-8 flex items-center justify-center rounded-full hover:bg-surface-darker text-text-secondary hover:text-white transition-colors"
                            onclick={() => (isOffcanvasOpen = false)}
                        >
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>

                    <div class="flex items-center gap-6">
                        <div
                            class="size-24 rounded-xl overflow-hidden shadow-2xl bg-surface-darker border border-border-dark shrink-0"
                        >
                            {#if selectedWork.recordings?.[0]?.cover}
                                <img
                                    src={selectedWork.recordings[0].cover}
                                    alt={selectedWork.title}
                                    class="w-full h-full object-cover"
                                />
                            {:else}
                                <div
                                    class="w-full h-full flex items-center justify-center text-text-muted"
                                >
                                    <span
                                        class="material-symbols-outlined text-4xl"
                                        >sketch</span
                                    >
                                </div>
                            {/if}
                        </div>
                        <div>
                            <h2 class="text-2xl font-bold text-white mb-1">
                                {selectedWork.title}
                            </h2>
                            <p class="text-primary font-medium">
                                {selectedWork.iswc}
                            </p>
                            <div class="flex gap-2 mt-2">
                                {#each selectedWork.contributors.slice(0, 2) as c}
                                    <span
                                        class="text-[10px] px-2 py-0.5 rounded bg-surface-darker border border-border-dark text-text-secondary uppercase font-bold"
                                    >
                                        {c.name}
                                    </span>
                                {/each}
                            </div>
                        </div>
                    </div>

                    <!-- Tabs -->
                    <div class="flex gap-8 mt-8 border-b border-border-dark">
                        {#each ["overview", "recordings", "rights"] as tab}
                            <button
                                class="pb-3 text-sm font-bold uppercase tracking-wider transition-all relative"
                                class:text-primary={activeTab === tab}
                                class:text-text-secondary={activeTab !== tab}
                                onclick={() => (activeTab = tab)}
                            >
                                {tab}
                                {#if activeTab === tab}
                                    <div
                                        class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"
                                        in:fade
                                    ></div>
                                {/if}
                            </button>
                        {/each}
                    </div>
                </div>

                <!-- Content -->
                <div class="flex-1 overflow-y-auto p-6">
                    {#if activeTab === "overview"}
                        <div class="space-y-8" in:fade>
                            <div class="grid grid-cols-2 gap-4">
                                <div
                                    class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                                >
                                    <p
                                        class="text-[10px] font-bold text-text-secondary uppercase tracking-widest mb-1"
                                    >
                                        Genre
                                    </p>
                                    <p class="text-lg font-bold">
                                        {selectedWork.metadata.genre}
                                    </p>
                                </div>
                                <div
                                    class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                                >
                                    <p
                                        class="text-[10px] font-bold text-text-secondary uppercase tracking-widest mb-1"
                                    >
                                        Mood
                                    </p>
                                    <p class="text-lg font-bold">
                                        {selectedWork.metadata.mood}
                                    </p>
                                </div>
                                <div
                                    class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                                >
                                    <p
                                        class="text-[10px] font-bold text-text-secondary uppercase tracking-widest mb-1"
                                    >
                                        BPM
                                    </p>
                                    <p class="text-lg font-bold">
                                        {selectedWork.metadata.bpm}
                                    </p>
                                </div>
                                <div
                                    class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                                >
                                    <p
                                        class="text-[10px] font-bold text-text-secondary uppercase tracking-widest mb-1"
                                    >
                                        Tempo
                                    </p>
                                    <p class="text-lg font-bold">
                                        {selectedWork.metadata.tempo}
                                    </p>
                                </div>
                            </div>

                            <div>
                                <h4
                                    class="text-sm font-bold uppercase tracking-widest text-text-secondary mb-4"
                                >
                                    Contributors
                                </h4>
                                <div class="space-y-3">
                                    {#each selectedWork.contributors as c}
                                        <div
                                            class="flex items-center justify-between p-3 rounded-lg bg-surface-darker/50 border border-border-dark/50"
                                        >
                                            <span class="font-medium"
                                                >{c.name}</span
                                            >
                                            <span
                                                class="text-xs px-2 py-0.5 rounded bg-primary/10 text-primary font-bold uppercase"
                                                >{c.role}</span
                                            >
                                        </div>
                                    {/each}
                                </div>
                            </div>

                            <div
                                class="p-6 rounded-2xl bg-gradient-to-br from-primary/20 to-transparent border border-primary/20"
                            >
                                <div class="flex items-center gap-3 mb-4">
                                    <span
                                        class="material-symbols-outlined text-primary"
                                        >insights</span
                                    >
                                    <h4 class="font-bold">Usage Summary</h4>
                                </div>
                                <div class="grid grid-cols-2 gap-8">
                                    <div>
                                        <p class="text-3xl font-bold">
                                            {selectedWork.plays}
                                        </p>
                                        <p
                                            class="text-xs text-text-secondary font-medium uppercase tracking-wider"
                                        >
                                            Total Plays
                                        </p>
                                    </div>
                                    <div>
                                        <p
                                            class="text-3xl font-bold text-primary"
                                        >
                                            {selectedWork.earnings}
                                        </p>
                                        <p
                                            class="text-xs text-text-secondary font-medium uppercase tracking-wider"
                                        >
                                            Accrued Royalties
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {:else if activeTab === "recordings"}
                        <div class="space-y-4" in:fade>
                            {#each selectedWork.recordings as rec}
                                <div
                                    class="p-4 rounded-xl bg-surface-darker border border-border-dark group hover:border-primary/50 transition-colors"
                                >
                                    <div
                                        class="flex justify-between items-start mb-4"
                                    >
                                        <div>
                                            <h5
                                                class="font-bold text-white transition-colors group-hover:text-primary"
                                            >
                                                {rec.title}
                                            </h5>
                                            <p
                                                class="text-xs text-text-secondary font-mono mt-1"
                                            >
                                                {rec.isrc}
                                            </p>
                                        </div>
                                        <span
                                            class="badge"
                                            class:badge-success={rec.status ===
                                                "Live"}
                                            class:badge-warning={rec.status ===
                                                "Pending"}
                                        >
                                            {rec.status}
                                        </span>
                                    </div>
                                    <div class="grid grid-cols-2 gap-4 text-xs">
                                        <div class="flex flex-col gap-1">
                                            <span
                                                class="text-text-secondary uppercase font-bold tracking-tighter"
                                                >Version</span
                                            >
                                            <span class="text-white"
                                                >{rec.version}</span
                                            >
                                        </div>
                                        <div class="flex flex-col gap-1">
                                            <span
                                                class="text-text-secondary uppercase font-bold tracking-tighter"
                                                >Duration</span
                                            >
                                            <span class="text-white"
                                                >{rec.duration}</span
                                            >
                                        </div>
                                        <div class="flex flex-col gap-1">
                                            <span
                                                class="text-text-secondary uppercase font-bold tracking-tighter"
                                                >Release Date</span
                                            >
                                            <span class="text-white"
                                                >{rec.releaseDate}</span
                                            >
                                        </div>
                                        <div class="flex flex-col gap-1">
                                            <span
                                                class="text-text-secondary uppercase font-bold tracking-tighter"
                                                >Fingerprint</span
                                            >
                                            <span class="text-white font-mono"
                                                >{rec.fingerprintId}</span
                                            >
                                        </div>
                                    </div>
                                </div>
                            {/each}
                        </div>
                    {:else if activeTab === "rights"}
                        <div class="space-y-8" in:fade>
                            <div>
                                <h4
                                    class="text-sm font-bold uppercase tracking-widest text-text-secondary mb-4"
                                >
                                    Work Splts (Composition)
                                </h4>
                                <div class="space-y-3">
                                    {#each selectedWork.work_rights as right}
                                        <div>
                                            <div
                                                class="flex justify-between mb-1 text-sm"
                                            >
                                                <span
                                                    >{right.name}
                                                    <span
                                                        class="text-text-secondary text-xs"
                                                        >({right.role})</span
                                                    ></span
                                                >
                                                <span
                                                    class="font-bold text-primary"
                                                    >{right.share}%</span
                                                >
                                            </div>
                                            <div
                                                class="w-full bg-surface-darker rounded-full h-1.5 overflow-hidden"
                                            >
                                                <div
                                                    class="bg-primary h-full"
                                                    style="width: {right.share}%"
                                                ></div>
                                            </div>
                                        </div>
                                    {/each}
                                </div>
                            </div>

                            <div class="pt-8 border-t border-border-dark">
                                <h4
                                    class="text-sm font-bold uppercase tracking-widest text-text-secondary mb-4"
                                >
                                    Recording Splts (Master)
                                </h4>
                                <div class="space-y-3">
                                    {#each selectedWork.recording_rights as right}
                                        <div>
                                            <div
                                                class="flex justify-between mb-1 text-sm"
                                            >
                                                <span
                                                    >{right.name}
                                                    <span
                                                        class="text-text-secondary text-xs"
                                                        >({right.role})</span
                                                    ></span
                                                >
                                                <span
                                                    class="font-bold text-primary"
                                                    >{right.share}%</span
                                                >
                                            </div>
                                            <div
                                                class="w-full bg-surface-darker rounded-full h-1.5 overflow-hidden"
                                            >
                                                <div
                                                    class="bg-primary h-full"
                                                    style="width: {right.share}%"
                                                ></div>
                                            </div>
                                        </div>
                                    {/each}
                                </div>
                            </div>

                            <button
                                class="w-full py-4 rounded-xl border-2 border-dashed border-border-dark text-text-secondary hover:text-white hover:border-primary transition-all font-bold uppercase tracking-widest text-xs flex items-center justify-center gap-2 mt-8"
                            >
                                <span class="material-symbols-outlined"
                                    >edit_note</span
                                >
                                Request Split Correction
                            </button>
                        </div>
                    {/if}
                </div>

                <!-- Footer -->
                <div
                    class="p-6 border-t border-border-dark bg-surface-dark/80 backdrop-blur-md"
                >
                    <div class="flex gap-3">
                        <button
                            class="flex-1 btn btn-secondary flex items-center justify-center gap-2"
                        >
                            <span class="material-symbols-outlined"
                                >download</span
                            >
                            Legal Title
                        </button>
                        <button
                            class="flex-1 btn btn-primary flex items-center justify-center gap-2"
                        >
                            <span class="material-symbols-outlined"
                                >analytics</span
                            >
                            Deep Stats
                        </button>
                    </div>
                </div>
            </div>
        </aside>
    {/if}

    <!-- Create New Work Offcanvas -->
    {#if isCreateOffcanvasOpen}
        <div
            class="fixed inset-0 bg-black/60 z-40 backdrop-blur-sm"
            role="button"
            tabindex="0"
            aria-label="Close form"
            onclick={() => (isCreateOffcanvasOpen = false)}
            onkeydown={(e) =>
                e.key === "Escape" && (isCreateOffcanvasOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>

        <aside
            class="fixed right-0 top-0 bottom-0 w-full max-w-[500px] border-l border-border-dark bg-surface-dark flex flex-col shadow-2xl z-50 transform"
            transition:fly={{ x: 500, duration: 400, opacity: 1 }}
        >
            <div class="flex flex-col h-full">
                <div
                    class="p-6 border-b border-border-dark flex items-center justify-between bg-surface-dark sticky top-0 z-10"
                >
                    <div>
                        <h2 class="text-xl font-bold text-white">
                            Register New Work
                        </h2>
                        <p class="text-xs text-text-secondary mt-1">
                            Provide the composition details to begin.
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
                    <!-- General Info -->
                    <div class="space-y-4">
                        <div class="space-y-2">
                            <label
                                class="text-xs font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="title">Work Title</label
                            >
                            <input
                                id="title"
                                type="text"
                                placeholder="Enter work title..."
                                class="input w-full"
                                bind:value={newWork.title}
                            />
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="space-y-2">
                                <label
                                    class="text-xs font-bold uppercase tracking-widest text-text-secondary ml-1"
                                    for="iswc">ISWC (Optional)</label
                                >
                                <input
                                    id="iswc"
                                    type="text"
                                    placeholder="T-000.000.000-0"
                                    class="input w-full font-mono text-xs"
                                    bind:value={newWork.iswc}
                                />
                            </div>
                            <div class="space-y-2">
                                <label
                                    class="text-xs font-bold uppercase tracking-widest text-text-secondary ml-1"
                                    for="genre">Genre</label
                                >
                                <select
                                    id="genre"
                                    class="select w-full"
                                    bind:value={newWork.genre}
                                >
                                    {#each genres.filter((g) => g !== "All") as g}
                                        <option value={g}>{g}</option>
                                    {/each}
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Contributors -->
                    <div class="space-y-4 pt-8 border-t border-border-dark/50">
                        <div class="flex items-center justify-between">
                            <h3
                                class="text-sm font-bold uppercase tracking-widest text-text-secondary"
                            >
                                Contributors
                            </h3>
                            <button
                                class="text-primary text-xs font-bold flex items-center gap-1 hover:underline"
                                onclick={addContributor}
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >add</span
                                > Add
                            </button>
                        </div>

                        <div class="space-y-3">
                            {#each newWork.contributors as c, i}
                                <div
                                    class="flex gap-2 items-start"
                                    transition:slide
                                >
                                    <div class="flex-1 space-y-2">
                                        <input
                                            type="text"
                                            placeholder="Name"
                                            class="input w-full py-2 text-sm"
                                            bind:value={c.name}
                                        />
                                    </div>
                                    <div class="w-32">
                                        <select
                                            class="select w-full py-2 text-sm"
                                            bind:value={c.role}
                                        >
                                            <option value="Composer"
                                                >Composer</option
                                            >
                                            <option value="Lyricist"
                                                >Lyricist</option
                                            >
                                            <option value="Arranger"
                                                >Arranger</option
                                            >
                                            <option value="Publisher"
                                                >Publisher</option
                                            >
                                        </select>
                                    </div>
                                    {#if newWork.contributors.length > 1}
                                        <button
                                            class="size-9 flex items-center justify-center text-text-muted hover:text-red-400"
                                            onclick={() => removeContributor(i)}
                                        >
                                            <span
                                                class="material-symbols-outlined text-lg"
                                                >delete</span
                                            >
                                        </button>
                                    {/if}
                                </div>
                            {/each}
                        </div>
                    </div>
                </div>

                <div
                    class="p-6 border-t border-border-dark bg-surface-darker/50 backdrop-blur-md"
                >
                    <button
                        class="w-full btn btn-primary py-4 font-bold uppercase tracking-widest flex items-center justify-center gap-2"
                        disabled={!newWork.title}
                        onclick={handleCreateWork}
                    >
                        <span class="material-symbols-outlined">save</span>
                        Register Work
                    </button>
                </div>
            </div>
        </aside>
    {/if}
</div>
