<script lang="ts">
    import { fly, fade, slide } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    // Mock Data based on Schema
    let sources = $state([
        {
            id: "src-001",
            name: "Classic 105",
            type: "commercial_radio",
            ingestion_type: "iot_device",
            country: "KE",
            region: "Nairobi",
            location: "Nairobi, KE",
            device_id: "OLAF-KE-001",
            status: "active",
            last_heartbeat: "2s ago",
            signal_strength: 92,
            royalty_rates: [
                {
                    method: "per_play",
                    rate: 5.0,
                    currency: "KES",
                    effective: "2025-01-01",
                    status: "Active",
                },
            ],
        },
        {
            id: "src-002",
            name: "Club 1824",
            type: "club",
            ingestion_type: "iot_device",
            country: "KE",
            region: "Nairobi",
            location: "Nairobi, KE",
            device_id: "OLAF-KE-004",
            status: "active",
            last_heartbeat: "12s ago",
            signal_strength: 85,
            royalty_rates: [
                {
                    method: "flat_fee",
                    rate: 15000.0,
                    currency: "KES",
                    effective: "2025-01-01",
                    status: "Active",
                },
            ],
        },
        {
            id: "src-003",
            name: "Radio Citizen",
            type: "commercial_radio",
            ingestion_type: "broadcast",
            country: "KE",
            region: "Limuru",
            location: "Limuru, KE",
            device_id: "OLAF-KE-022",
            status: "active",
            last_heartbeat: "5s ago",
            signal_strength: 98,
            royalty_rates: [
                {
                    method: "per_play",
                    rate: 6.5,
                    currency: "KES",
                    effective: "2024-06-01",
                    status: "Active",
                },
            ],
        },
        {
            id: "src-004",
            name: "KISS 100",
            type: "commercial_radio",
            ingestion_type: "web_stream",
            country: "KE",
            region: "Nairobi",
            location: "Nairobi, KE",
            device_id: "N/A",
            status: "offline",
            last_heartbeat: "2h ago",
            signal_strength: 0,
            royalty_rates: [
                {
                    method: "per_play",
                    rate: 5.0,
                    currency: "KES",
                    effective: "2025-01-01",
                    status: "Active",
                },
            ],
        },
    ]);

    // Generate more mock data
    for (let i = 0; i < 40; i++) {
        const country = i % 5 === 0 ? "UG" : "KE";
        const region = i % 5 === 0 ? "Kampala" : "Nairobi";
        sources.push({
            id: `src-gen-${i}`,
            name: `Test Source ${i + 1}`,
            type:
                i % 3 === 0
                    ? "matatu"
                    : i % 2 === 0
                      ? "hotel"
                      : "community_radio",
            ingestion_type: "iot_device",
            country: country,
            region: region,
            location: `${region}, ${country}`,
            device_id: `OLAF-${country}-${100 + i}`,
            status: i % 10 === 0 ? "maintenance" : "active",
            last_heartbeat: `${i * 2}s ago`,
            signal_strength: Math.floor(Math.random() * 100),
            royalty_rates: [],
        });
    }

    // Options derived from Schema
    const sourceTypes = [
        "commercial_radio",
        "community_radio",
        "public_broadcaster",
        "tv_station",
        "club",
        "hotel",
        "restaurant",
        "shop_retail",
        "matatu",
        "digital_service",
    ];
    const ingestionTypes = [
        "iot_device",
        "web_stream",
        "digital_dsp",
        "broadcast",
        "file_upload",
    ];
    const countries = ["All", "KE", "UG", "TZ", "ZA", "GH", "NG"];
    const statuses = ["All", "active", "inactive", "maintenance", "offline"];
    const calculationMethods = [
        "per_play",
        "scientific_distribution",
        "general_distribution",
        "percentage_revenue",
        "flat_fee",
        "duration_based",
    ];

    // Filters
    let searchQuery = $state("");
    let filterType = $state("All");
    let filterStatus = $state("All");
    let filterCountry = $state("All");

    // Derived filtered sources
    let filteredSources = $derived(
        sources.filter((s) => {
            const matchSearch =
                s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                s.device_id.toLowerCase().includes(searchQuery.toLowerCase()) ||
                s.location.toLowerCase().includes(searchQuery.toLowerCase());
            const matchType = filterType === "All" || s.type === filterType;
            const matchStatus =
                filterStatus === "All" || s.status === filterStatus;
            const matchCountry =
                filterCountry === "All" || s.country === filterCountry;

            return matchSearch && matchType && matchStatus && matchCountry;
        }),
    );

    // Selection & Offcanvas State
    let selectedSourceId = $state<string | null>(null);
    let isCreateOpen = $state(false);
    let isDetailOpen = $state(false);
    let activeDetailTab = $state("overview"); // 'overview' | 'rates'

    let selectedSource = $derived(
        sources.find((s) => s.id === selectedSourceId),
    );

    function openDetail(id: string) {
        selectedSourceId = id;
        isDetailOpen = true;
        activeDetailTab = "overview";
    }

    function closeDetail() {
        isDetailOpen = false;
        setTimeout(() => (selectedSourceId = null), 300);
    }

    // Create Form State
    let newSource = $state({
        name: "",
        type: "commercial_radio",
        ingestion_type: "iot_device",
        country: "KE",
        region: "",
        device_id: "",
        stream_url: "",
    });

    function createSource() {
        // Mock create
        const id = `src-new-${Date.now()}`;
        sources = [
            {
                id: id,
                ...newSource,
                location: `${newSource.region}, ${newSource.country}`,
                status: "inactive",
                last_heartbeat: "Never",
                signal_strength: 0,
                royalty_rates: [],
            },
            ...sources,
        ];
        isCreateOpen = false;
        // Reset
        newSource = {
            name: "",
            type: "commercial_radio",
            ingestion_type: "iot_device",
            country: "KE",
            region: "",
            device_id: "",
            stream_url: "",
        };

        // Open the newly created source
        openDetail(id);
    }

    function formatEnum(t: string | undefined) {
        if (!t) return "";
        return t
            .split("_")
            .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
            .join(" ");
    }

    // Reset Filters
    function resetFilters() {
        searchQuery = "";
        filterType = "All";
        filterStatus = "All";
        filterCountry = "All";
    }
</script>

<svelte:head>
    <title>Sources | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <!-- Top Bar / Header -->
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-surface-dark/95 backdrop-blur-sm z-30 px-8 flex flex-col justify-center"
    >
        <!-- Breadcrumbs -->
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
                >Monitoring Sources</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-surface-darker border border-border-dark flex items-center justify-center text-primary shadow-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >sensors</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-white tracking-tight leading-none"
                    >
                        Monitoring Sources
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Manage ingestion points and royalty rates
                    </p>
                </div>
            </div>

            <div class="flex items-center gap-3">
                <button
                    class="h-9 px-4 btn-primary rounded-lg flex items-center gap-2 shadow-lg shadow-primary/10 hover:shadow-primary/20 transition-all font-bold uppercase tracking-widest text-[10px]"
                    onclick={() => (isCreateOpen = true)}
                >
                    <span class="material-symbols-outlined text-lg">add</span>
                    Add Source
                </button>
            </div>
        </div>
    </header>

    <!-- Filters Bar -->
    <div
        class="h-14 shrink-0 border-b border-border-dark bg-surface-dark/50 px-8 flex items-center gap-4 z-20 overflow-x-auto scrollbar-none"
    >
        <!-- Search Integrated into Filters -->
        <div class="relative group min-w-[240px]">
            <span
                class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-text-muted text-lg"
                >search</span
            >
            <input
                type="text"
                placeholder="Search name, ID or location..."
                class="h-8 w-full bg-surface-darker border border-border-dark rounded-md pl-9 pr-4 text-xs text-white placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/50 transition-all font-medium"
                bind:value={searchQuery}
            />
        </div>

        <div class="h-6 w-px bg-border-dark mx-2"></div>

        <div class="flex items-center gap-3">
            <div class="relative group">
                <select
                    class="h-8 w-36 appearance-none bg-surface-darker border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/30"
                    bind:value={filterType}
                >
                    <option value="All">All Types</option>
                    {#each sourceTypes as t}
                        <option value={t}>{formatEnum(t)}</option>
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >expand_more</span
                >
            </div>

            <div class="relative group">
                <select
                    class="h-8 w-28 appearance-none bg-surface-darker border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/30"
                    bind:value={filterCountry}
                >
                    {#each countries as c}
                        <option value={c}
                            >{c === "All" ? "All Countries" : c}</option
                        >
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >expand_more</span
                >
            </div>

            <div class="relative group">
                <select
                    class="h-8 w-32 appearance-none bg-surface-darker border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/30"
                    bind:value={filterStatus}
                >
                    {#each statuses as s}
                        <option value={s}
                            >{s === "All"
                                ? "All Status"
                                : formatEnum(s)}</option
                        >
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >expand_more</span
                >
            </div>
        </div>

        {#if searchQuery || filterType !== "All" || filterStatus !== "All" || filterCountry !== "All"}
            <button
                class="ml-auto text-[10px] text-primary font-bold uppercase tracking-widest hover:underline"
                onclick={resetFilters}
            >
                Clear Filters
            </button>
        {/if}
    </div>

    <!-- Data Table -->
    <main class="flex-1 overflow-auto relative">
        <table class="w-full text-left border-collapse">
            <thead class="sticky top-0 z-10 bg-surface-dark shadow-sm">
                <tr>
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[25%]"
                        >Source Name</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Type</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Location</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Hardware ID</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[10%]"
                        >Ingest</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[10%]"
                        >Status</th
                    >
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark text-right w-[10%]"
                        >Last Beat</th
                    >
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark/30">
                {#each filteredSources as source}
                    <tr
                        class="group hover:bg-surface-darker/50 transition-colors cursor-pointer"
                        onclick={() => openDetail(source.id)}
                    >
                        <td class="py-3 px-8">
                            <div class="flex items-center gap-3">
                                <div
                                    class="size-8 rounded bg-surface-darker border border-border-dark flex items-center justify-center text-text-secondary group-hover:border-primary/30 group-hover:text-primary transition-colors"
                                >
                                    <span
                                        class="material-symbols-outlined text-lg"
                                    >
                                        {source.type.includes("radio")
                                            ? "radio"
                                            : source.type === "web_stream"
                                              ? "podcasts"
                                              : "router"}
                                    </span>
                                </div>
                                <div>
                                    <div
                                        class="text-sm font-semibold text-white group-hover:text-primary transition-colors"
                                    >
                                        {source.name}
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <span
                                class="px-2 py-0.5 rounded-full border border-border-dark bg-surface-darker text-[9px] font-bold uppercase tracking-wider text-text-secondary"
                            >
                                {formatEnum(source.type)}
                            </span>
                        </td>
                        <td
                            class="py-3 px-4 text-xs text-text-secondary font-medium"
                            >{source.location}</td
                        >
                        <td
                            class="py-3 px-4 text-xs font-mono text-text-muted uppercase"
                            >{source.device_id}</td
                        >
                        <td
                            class="py-3 px-4 text-xs text-text-secondary font-medium"
                            >{formatEnum(source.ingestion_type)}</td
                        >
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-1.5">
                                <span
                                    class="size-1.5 rounded-full {source.status ===
                                    'active'
                                        ? 'bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.4)]'
                                        : source.status === 'maintenance'
                                          ? 'bg-amber-500'
                                          : 'bg-red-500'}"
                                ></span>
                                <span
                                    class="text-[10px] font-bold uppercase tracking-wider {source.status ===
                                    'active'
                                        ? 'text-emerald-400'
                                        : source.status === 'maintenance'
                                          ? 'text-amber-400'
                                          : 'text-red-400'}"
                                >
                                    {formatEnum(source.status)}
                                </span>
                            </div>
                        </td>
                        <td
                            class="py-3 px-8 text-right text-xs font-mono text-text-muted"
                            >{source.last_heartbeat}</td
                        >
                    </tr>
                {:else}
                    <tr>
                        <td colspan="7" class="py-20 text-center">
                            <div
                                class="flex flex-col items-center justify-center opacity-40"
                            >
                                <span
                                    class="material-symbols-outlined text-4xl mb-2"
                                    >sensor_window</span
                                >
                                <p class="text-sm font-medium">
                                    No sources found matching your filters
                                </p>
                                <button
                                    class="mt-4 text-xs text-primary hover:underline"
                                    onclick={resetFilters}>Clear Filters</button
                                >
                            </div>
                        </td>
                    </tr>
                {/each}
            </tbody>
        </table>
    </main>

    <!-- Status Footer -->
    <footer
        class="h-10 shrink-0 border-t border-border-dark bg-surface-dark px-8 flex items-center justify-between text-[10px] font-mono text-text-muted uppercase tracking-widest"
    >
        <div>Showing {filteredSources.length} sources</div>
        <div class="flex gap-4">
            <span class="flex items-center gap-1.5"
                ><span class="size-1.5 bg-emerald-500 rounded-full"></span> Active</span
            >
            <span class="flex items-center gap-1.5"
                ><span class="size-1.5 bg-amber-500 rounded-full"></span> Maintenance</span
            >
            <span class="flex items-center gap-1.5"
                ><span class="size-1.5 bg-red-500 rounded-full"></span> Offline</span
            >
        </div>
    </footer>

    <!-- Create Source Offcanvas -->
    {#if isCreateOpen}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isCreateOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[450px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <div
                class="p-5 border-b border-border-dark flex items-center justify-between bg-surface-dark relative"
            >
                <div>
                    <h2 class="text-lg font-bold text-white tracking-tight">
                        New Source
                    </h2>
                    <p
                        class="text-[10px] text-text-secondary font-medium mt-0.5"
                    >
                        Register a new ingestion point
                    </p>
                </div>
                <button
                    class="size-7 flex items-center justify-center rounded-lg hover:bg-surface-darker text-text-muted hover:text-white transition-colors"
                    onclick={() => (isCreateOpen = false)}
                >
                    <span class="material-symbols-outlined text-lg">close</span>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto p-6 space-y-6">
                <!-- Form Fields -->
                <div class="space-y-4">
                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Source Name</label
                        >
                        <input
                            type="text"
                            class="input w-full"
                            placeholder="e.g. Capital FM Nairobi"
                            bind:value={newSource.name}
                        />
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Type</label
                            >
                            <select
                                class="select w-full"
                                bind:value={newSource.type}
                            >
                                {#each sourceTypes as t}
                                    <option value={t}>{formatEnum(t)}</option>
                                {/each}
                            </select>
                        </div>
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Ingestion</label
                            >
                            <select
                                class="select w-full"
                                bind:value={newSource.ingestion_type}
                            >
                                {#each ingestionTypes as t}
                                    <option value={t}>{formatEnum(t)}</option>
                                {/each}
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Country</label
                            >
                            <select
                                class="select w-full"
                                bind:value={newSource.country}
                            >
                                {#each countries.filter((c) => c !== "All") as c}
                                    <option value={c}>{c}</option>
                                {/each}
                            </select>
                        </div>
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Region/City</label
                            >
                            <input
                                type="text"
                                class="input w-full"
                                placeholder="e.g. Mombasa"
                                bind:value={newSource.region}
                            />
                        </div>
                    </div>

                    <div class="pt-4 border-t border-border-dark/30 space-y-4">
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Device ID (OLAF)</label
                            >
                            <input
                                type="text"
                                class="input w-full text-emerald-400 font-mono"
                                placeholder="OLAF-XX-XXX"
                                bind:value={newSource.device_id}
                            />
                            <p class="text-[9px] text-text-muted">
                                Required for IoT ingestion types.
                            </p>
                        </div>
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Stream URL</label
                            >
                            <input
                                type="text"
                                class="input w-full"
                                placeholder="https://..."
                                bind:value={newSource.stream_url}
                            />
                            <p class="text-[9px] text-text-muted">
                                Required for Web Stream ingestion.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div
                class="p-5 border-t border-border-dark bg-surface-dark/50 backdrop-blur-sm"
            >
                <button
                    class="w-full btn-primary py-3 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 hover:shadow-primary/30 transition-all flex items-center justify-center gap-2"
                    onclick={createSource}
                    disabled={!newSource.name}
                >
                    <span class="material-symbols-outlined text-lg">save</span>
                    Create Source
                </button>
            </div>
        </aside>
    {/if}

    <!-- Detail View Offcanvas -->
    {#if isDetailOpen && selectedSource}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={closeDetail}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[600px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <!-- Header -->
            <div
                class="h-40 shrink-0 relative bg-surface-darker border-b border-border-dark overflow-hidden group"
            >
                <!-- Background Pattern -->
                <div
                    class="absolute inset-0 opacity-10 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:16px_16px]"
                ></div>
                <div
                    class="absolute inset-0 bg-gradient-to-t from-surface-darker via-transparent to-transparent"
                ></div>

                <div class="absolute top-4 right-4 z-10">
                    <button
                        class="size-8 rounded-full bg-black/40 hover:bg-black/60 backdrop-blur text-white flex items-center justify-center transition-all"
                        onclick={closeDetail}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <div
                    class="absolute bottom-0 left-0 right-0 p-6 flex items-end gap-5"
                >
                    <div
                        class="size-16 rounded-xl bg-surface-dark border border-border-dark flex items-center justify-center text-primary shadow-xl"
                    >
                        <span class="material-symbols-outlined text-4xl">
                            {selectedSource.type.includes("radio")
                                ? "radio"
                                : selectedSource.type === "web_stream"
                                  ? "podcasts"
                                  : "router"}
                        </span>
                    </div>
                    <div class="flex-1 mb-1">
                        <div class="flex items-center gap-3">
                            <h2
                                class="text-2xl font-bold text-white tracking-tight"
                            >
                                {selectedSource.name}
                            </h2>
                            <span
                                class="px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-widest {selectedSource.status ===
                                'active'
                                    ? 'bg-emerald-500/10 text-emerald-400'
                                    : 'bg-red-500/10 text-red-500'}"
                            >
                                {formatEnum(selectedSource.status)}
                            </span>
                        </div>
                        <div
                            class="flex items-center gap-3 text-xs text-text-muted mt-1 font-medium"
                        >
                            <span class="flex items-center gap-1"
                                ><span class="material-symbols-outlined text-sm"
                                    >location_on</span
                                >
                                {selectedSource.location}</span
                            >
                            <span class="text-border-dark">|</span>
                            <span class="font-mono"
                                >{selectedSource.device_id}</span
                            >
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabs -->
            <div
                class="h-12 shrink-0 border-b border-border-dark bg-surface-dark px-6 flex items-center gap-6"
            >
                <button
                    class="h-full border-b-2 text-[10px] font-bold uppercase tracking-widest transition-colors {activeDetailTab ===
                    'overview'
                        ? 'border-primary text-primary'
                        : 'border-transparent text-text-muted hover:text-white'}"
                    onclick={() => (activeDetailTab = "overview")}
                    >Overview</button
                >
                <button
                    class="h-full border-b-2 text-[10px] font-bold uppercase tracking-widest transition-colors {activeDetailTab ===
                    'rates'
                        ? 'border-primary text-primary'
                        : 'border-transparent text-text-muted hover:text-white'}"
                    onclick={() => (activeDetailTab = "rates")}
                    >Royalty Rates</button
                >
            </div>

            <!-- Content -->
            <div class="flex-1 overflow-y-auto p-6">
                {#if activeDetailTab === "overview"}
                    <div class="space-y-6" in:fade={{ duration: 200 }}>
                        <!-- Signal Monitor -->
                        <div
                            class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                        >
                            <div class="flex items-center justify-between mb-4">
                                <h3
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                >
                                    Signal Quality
                                </h3>
                                <span
                                    class="text-xs font-mono font-bold text-emerald-400"
                                    >{selectedSource.signal_strength}%</span
                                >
                            </div>
                            <!-- Simulated Graph -->
                            <div
                                class="h-24 flex items-end gap-1 overflow-hidden"
                            >
                                {#each Array(40) as _, i}
                                    <div
                                        class="flex-1 bg-primary/20 rounded-t-sm"
                                        style="height: {Math.random() * 60 +
                                            20}%"
                                    ></div>
                                {/each}
                            </div>
                        </div>

                        <!-- Details Grid -->
                        <div class="grid grid-cols-2 gap-4">
                            <div
                                class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                            >
                                <span
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                                    >Ingestion Type</span
                                >
                                <p
                                    class="text-sm font-semibold text-white mt-1"
                                >
                                    {formatEnum(selectedSource.ingestion_type)}
                                </p>
                            </div>
                            <div
                                class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                            >
                                <span
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                                    >Last Heartbeat</span
                                >
                                <p
                                    class="text-sm font-semibold text-white mt-1"
                                >
                                    {selectedSource.last_heartbeat}
                                </p>
                            </div>
                            <div
                                class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                            >
                                <span
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                                    >Country</span
                                >
                                <p
                                    class="text-sm font-semibold text-white mt-1"
                                >
                                    {selectedSource.country}
                                </p>
                            </div>
                            <div
                                class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                            >
                                <span
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                                    >Region</span
                                >
                                <p
                                    class="text-sm font-semibold text-white mt-1"
                                >
                                    {selectedSource.region}
                                </p>
                            </div>
                        </div>
                    </div>
                {:else if activeDetailTab === "rates"}
                    <div class="space-y-4" in:fade={{ duration: 200 }}>
                        <div class="flex items-center justify-between">
                            <h3 class="text-xs font-bold text-white">
                                Configured Rates
                            </h3>
                            <button
                                class="text-[10px] text-primary font-bold uppercase tracking-widest hover:underline"
                                >+ Add Rate</button
                            >
                        </div>

                        {#if selectedSource.royalty_rates.length > 0}
                            <div
                                class="border border-border-dark rounded-xl overflow-hidden"
                            >
                                <table class="w-full text-left">
                                    <thead
                                        class="bg-surface-darker border-b border-border-dark"
                                    >
                                        <tr>
                                            <th
                                                class="py-2 px-4 text-[9px] font-bold uppercase tracking-widest text-text-muted"
                                                >Method</th
                                            >
                                            <th
                                                class="py-2 px-4 text-[9px] font-bold uppercase tracking-widest text-text-muted"
                                                >Rate</th
                                            >
                                            <th
                                                class="py-2 px-4 text-[9px] font-bold uppercase tracking-widest text-text-muted"
                                                >Effective</th
                                            >
                                            <th
                                                class="py-2 px-4 text-[9px] font-bold uppercase tracking-widest text-text-muted text-right"
                                                >Status</th
                                            >
                                        </tr>
                                    </thead>
                                    <tbody
                                        class="divide-y divide-border-dark/30"
                                    >
                                        {#each selectedSource.royalty_rates as rate}
                                            <tr>
                                                <td
                                                    class="py-3 px-4 text-xs font-medium text-white"
                                                    >{formatEnum(
                                                        rate.method,
                                                    )}</td
                                                >
                                                <td
                                                    class="py-3 px-4 text-xs font-mono text-emerald-400"
                                                    >{rate.currency}
                                                    {rate.rate.toFixed(2)}</td
                                                >
                                                <td
                                                    class="py-3 px-4 text-xs text-text-secondary"
                                                    >{rate.effective}</td
                                                >
                                                <td
                                                    class="py-3 px-4 text-right"
                                                >
                                                    <span
                                                        class="px-1.5 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider bg-emerald-500/10 text-emerald-400"
                                                        >Active</span
                                                    >
                                                </td>
                                            </tr>
                                        {/each}
                                    </tbody>
                                </table>
                            </div>
                        {:else}
                            <div
                                class="p-8 text-center border-2 border-dashed border-border-dark rounded-xl"
                            >
                                <p class="text-xs text-text-muted">
                                    No royalty rates configured for this source.
                                </p>
                            </div>
                        {/if}
                    </div>
                {/if}
            </div>
        </aside>
    {/if}
</div>

<style>
    .input {
        height: 2.5rem;
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.5rem;
        padding-left: 0.75rem;
        padding-right: 0.75rem;
        color: white;
        font-size: 0.75rem;
        font-weight: 500;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: rgba(16, 185, 129, 0.5);
        box-shadow: 0 0 0 1px rgba(16, 185, 129, 0.2);
    }
    .select {
        height: 2.5rem;
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.5rem;
        padding-left: 0.75rem;
        padding-right: 2rem;
        color: white;
        font-size: 0.75rem;
        font-weight: 500;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(148, 163, 184, 1)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 0.5rem center;
        background-size: 1rem;
    }

    /* Hide scrollbar for Chrome, Safari and Opera */
    .scrollbar-none::-webkit-scrollbar {
        display: none;
    }

    /* Hide scrollbar for IE, Edge and Firefox */
    .scrollbar-none {
        -ms-overflow-style: none; /* IE and Edge */
        scrollbar-width: none; /* Firefox */
    }
</style>
