<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // Mock Sources Data
    const sources = [
        {
            id: "src-001",
            name: "Classic 105",
            type: "commercial_radio",
            status: "active",
            location: "Nairobi, KE",
            coordinates: [-1.2921, 36.8219],
            last_heartbeat: "2s ago",
            device_id: "OLAF-KE-001",
        },
        {
            id: "src-002",
            name: "Club 1824",
            type: "club",
            status: "active",
            location: "Nairobi, KE",
            coordinates: [-1.3093, 36.8125],
            last_heartbeat: "12s ago",
            device_id: "OLAF-KE-004",
        },
        {
            id: "src-003",
            name: "Radio Citizen",
            type: "commercial_radio",
            status: "active",
            location: "Limuru, KE",
            coordinates: [-1.1147, 36.6437],
            last_heartbeat: "5s ago",
            device_id: "OLAF-KE-022",
        },
        {
            id: "src-004",
            name: "KISS 100",
            type: "commercial_radio",
            status: "offline",
            location: "Nairobi, KE",
            coordinates: [-1.2841, 36.8155],
            last_heartbeat: "2h ago",
            device_id: "OLAF-KE-002",
        },
    ];

    let selectedSourceId = $state<string | null>(null);
    let showConfig = $state(false);
    let mapPlaceholder: HTMLElement;

    function selectSource(id: string) {
        selectedSourceId = id;
    }

    function toggleConfig() {
        showConfig = !showConfig;
    }
</script>

<svelte:head>
    <title>Sources | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full overflow-hidden -m-4 md:-m-8">
    <!-- Left: Source List -->
    <div
        class="w-1/3 min-w-[350px] flex flex-col border-r border-border-dark bg-surface-darker"
    >
        <!-- Header -->
        <div class="p-6 border-b border-border-dark shrink-0">
            <div class="flex justify-between items-center mb-4">
                <h1 class="text-2xl font-bold tracking-tight text-white">
                    Sources
                </h1>
                <button
                    class="btn-primary p-2"
                    onclick={toggleConfig}
                    title="Add Source"
                >
                    <span class="material-symbols-outlined">add</span>
                </button>
            </div>
            <div class="relative">
                <span
                    class="material-symbols-outlined absolute left-3 top-2.5 text-text-muted"
                    >search</span
                >
                <input
                    type="text"
                    placeholder="Search sources..."
                    class="input pl-10 w-full text-sm"
                />
            </div>
        </div>

        <!-- List -->
        <div class="flex-1 overflow-auto">
            {#each sources as source}
                <button
                    class="w-full text-left p-4 border-b border-border-dark/50 hover:bg-surface-dark transition-colors flex justify-between items-center group relative"
                    class:bg-surface-dark={selectedSourceId === source.id}
                    onclick={() => selectSource(source.id)}
                >
                    <div class="flex items-center gap-4">
                        <div
                            class="size-10 rounded-full flex items-center justify-center bg-background-dark border border-border-dark text-text-secondary"
                        >
                            <span class="material-symbols-outlined">
                                {source.type === "commercial_radio"
                                    ? "radio"
                                    : source.type === "club"
                                      ? "nightlife"
                                      : "router"}
                            </span>
                        </div>
                        <div>
                            <h3 class="font-bold text-white text-sm">
                                {source.name}
                            </h3>
                            <p class="text-xs text-text-secondary">
                                {source.location}
                            </p>
                        </div>
                    </div>
                    <div class="flex flex-col items-end gap-1">
                        {#if source.status === "active"}
                            <span
                                class="badge badge-success text-[10px] uppercase"
                                >Online</span
                            >
                            <span class="text-[10px] text-text-muted"
                                >{source.last_heartbeat}</span
                            >
                        {:else}
                            <span
                                class="badge bg-red-500/10 text-red-500 border-red-500/20 text-[10px] uppercase"
                                >Offline</span
                            >
                            <span class="text-[10px] text-text-muted"
                                >Lost signal</span
                            >
                        {/if}
                    </div>
                    {#if selectedSourceId === source.id}
                        <div
                            class="absolute left-0 top-0 bottom-0 w-1 bg-primary"
                        ></div>
                    {/if}
                </button>
            {/each}
        </div>
    </div>

    <!-- Right: Map View -->
    <div class="flex-1 bg-background-dark relative flex flex-col">
        <!-- Map Placeholder -->
        <div class="flex-1 relative bg-[#1c2e28] overflow-hidden group">
            <!-- Simulated Map Pattern -->
            <div
                class="absolute inset-0 opacity-10"
                style="background-image: radial-gradient(#ffffff 1px, transparent 1px); background-size: 20px 20px;"
            ></div>

            <!-- Pins -->
            {#each sources as source}
                <div
                    class="absolute flex flex-col items-center gap-1 cursor-pointer transition-transform hover:scale-110 z-10"
                    style="top: {50 + (Math.random() * 40 - 20)}%; left: {50 +
                        (Math.random() * 40 - 20)}%;"
                >
                    <div class="relative group/pin">
                        <span
                            class="material-symbols-outlined text-4xl {source.status ===
                            'active'
                                ? 'text-emerald-500'
                                : 'text-red-500'} drop-shadow-lg"
                            >location_on</span
                        >
                        <div
                            class="absolute -top-10 left-1/2 -translate-x-1/2 bg-surface-darker px-2 py-1 rounded text-xs font-bold whitespace-nowrap opacity-0 group-hover/pin:opacity-100 transition-opacity border border-border-dark shadow-xl z-20 pointer-events-none"
                        >
                            {source.name}
                        </div>
                    </div>
                </div>
            {/each}

            <div class="absolute bottom-6 right-6 flex flex-col gap-2">
                <button
                    class="size-10 bg-surface-darker border border-border-dark rounded flex items-center justify-center text-text-main shadow-lg hover:bg-surface-dark"
                >
                    <span class="material-symbols-outlined">add</span>
                </button>
                <button
                    class="size-10 bg-surface-darker border border-border-dark rounded flex items-center justify-center text-text-main shadow-lg hover:bg-surface-dark"
                >
                    <span class="material-symbols-outlined">remove</span>
                </button>
            </div>
        </div>

        <!-- Inspector (Bottom Pane for Selected Source) -->
        {#if selectedSourceId}
            {@const activeSource = sources.find(
                (s) => s.id === selectedSourceId,
            )}
            <div
                class="h-64 bg-surface-darker border-t border-border-dark p-6 flex gap-8 shrink-0 animate-in slide-in-from-bottom duration-300"
            >
                <div class="w-1/3 border-r border-border-dark pr-8">
                    <div class="flex items-center gap-3 mb-4">
                        <div
                            class="size-12 rounded-lg bg-surface-dark border border-border-dark flex items-center justify-center"
                        >
                            <span
                                class="material-symbols-outlined text-2xl text-text-main"
                            >
                                {activeSource?.type === "commercial_radio"
                                    ? "radio"
                                    : "router"}
                            </span>
                        </div>
                        <div>
                            <h2
                                class="text-xl font-bold text-white leading-none mb-1"
                            >
                                {activeSource?.name}
                            </h2>
                            <div class="flex items-center gap-2">
                                <span
                                    class="text-xs font-mono text-text-secondary"
                                    >{activeSource?.device_id}</span
                                >
                                <span
                                    class="size-1.5 rounded-full bg-text-muted"
                                ></span>
                                <span class="text-xs text-text-secondary"
                                    >{activeSource?.location}</span
                                >
                            </div>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div
                            class="p-3 rounded bg-background-dark border border-border-dark"
                        >
                            <span
                                class="text-xs text-text-muted uppercase font-bold block mb-1"
                                >Status</span
                            >
                            <div class="flex items-center gap-2">
                                <span
                                    class="size-2 rounded-full {activeSource?.status ===
                                    'active'
                                        ? 'bg-emerald-500'
                                        : 'bg-red-500'}"
                                ></span>
                                <span
                                    class="text-sm font-medium text-text-main capitalize"
                                    >{activeSource?.status}</span
                                >
                            </div>
                        </div>
                        <div
                            class="p-3 rounded bg-background-dark border border-border-dark"
                        >
                            <span
                                class="text-xs text-text-muted uppercase font-bold block mb-1"
                                >Heartbeat</span
                            >
                            <span class="text-sm font-medium text-text-main"
                                >{activeSource?.last_heartbeat}</span
                            >
                        </div>
                    </div>
                </div>
                <div class="flex-1">
                    <h3
                        class="text-sm font-bold text-text-secondary uppercase tracking-wider mb-4"
                    >
                        Ingestion Monitor
                    </h3>
                    <!-- Fake Graph -->
                    <div
                        class="w-full h-32 bg-background-dark rounded border border-border-dark overflow-hidden relative flex items-end gap-1 px-1 pb-1"
                    >
                        {#each Array(40) as _, i}
                            <div
                                class="flex-1 bg-primary/20 hover:bg-primary/50 transition-colors rounded-t-sm"
                                style="height: {Math.random() * 100}%"
                            ></div>
                        {/each}
                    </div>
                </div>
            </div>
        {/if}
    </div>

    <!-- Source Config Offcanvas -->
    {#if showConfig}
        <div
            class="absolute inset-0 z-50 bg-black/50 backdrop-blur-sm"
            onclick={toggleConfig}
            aria-hidden="true"
        ></div>
        <div
            class="absolute top-0 right-0 bottom-0 w-[400px] bg-surface-darker border-l border-border-dark z-50 shadow-2xl p-0 flex flex-col animate-in slide-in-from-right duration-300"
        >
            <div
                class="p-6 border-b border-border-dark flex justify-between items-center bg-surface-dark"
            >
                <h2 class="text-lg font-bold text-white">Configure Source</h2>
                <button
                    onclick={toggleConfig}
                    class="text-text-secondary hover:text-white"
                >
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <div class="flex-1 overflow-y-auto p-6 space-y-6">
                <section>
                    <label
                        class="block text-sm font-bold text-text-secondary mb-2"
                        >Source Name</label
                    >
                    <input
                        type="text"
                        class="input w-full"
                        placeholder="e.g. Classic 105"
                    />
                </section>

                <section>
                    <label
                        class="block text-sm font-bold text-text-secondary mb-2"
                        >Source Type</label
                    >
                    <div class="grid grid-cols-2 gap-3">
                        <button
                            class="p-3 rounded border border-primary bg-primary/10 text-primary flex flex-col items-center gap-2"
                        >
                            <span class="material-symbols-outlined">router</span
                            >
                            <span class="text-xs font-bold">IoT Device</span>
                        </button>
                        <button
                            class="p-3 rounded border border-border-dark bg-background-dark text-text-secondary hover:border-text-muted flex flex-col items-center gap-2"
                        >
                            <span class="material-symbols-outlined"
                                >podcasts</span
                            >
                            <span class="text-xs font-bold">Web Stream</span>
                        </button>
                    </div>
                </section>

                <section>
                    <label
                        class="block text-sm font-bold text-text-secondary mb-2"
                        >Device ID</label
                    >
                    <div class="flex gap-2">
                        <input
                            type="text"
                            class="input w-full font-mono"
                            placeholder="OLAF-XXXX-XXXX"
                        />
                        <button class="btn-secondary">Pair</button>
                    </div>
                    <p class="text-xs text-text-muted mt-2">
                        Enter the serial number found on the back of the OLAF
                        Box.
                    </p>
                </section>

                <section>
                    <label
                        class="block text-sm font-bold text-text-secondary mb-2"
                        >Geolocation</label
                    >
                    <div
                        class="h-40 bg-background-dark rounded border border-border-dark flex items-center justify-center cursor-crosshair hover:border-primary transition-colors"
                    >
                        <span
                            class="text-text-secondary text-sm flex items-center gap-2"
                        >
                            <span class="material-symbols-outlined"
                                >add_location</span
                            >
                            Click to pin location
                        </span>
                    </div>
                </section>
            </div>
            <div
                class="p-6 border-t border-border-dark bg-surface-dark flex justify-end gap-3"
            >
                <button class="btn-ghost" onclick={toggleConfig}>Cancel</button>
                <button class="btn-primary" onclick={toggleConfig}
                    >Save Configuration</button
                >
            </div>
        </div>
    {/if}
</div>
