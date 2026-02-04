<script lang="ts">
    import type { PageData } from "./$types";
    import { fade, slide, fly } from "svelte/transition";

    let { data }: { data: PageData } = $props();

    // Mock Rights Holders Data
    const baseHolders = [
        {
            id: "rh-1",
            name: "Sauti Sol",
            ipi: "00123456789",
            type: "Performer",
            worksCount: 145,
            status: "Active",
            avatar: "person",
            email: "management@sautisol.com",
            phone: "+254 712 345 678",
            country: "Kenya",
        },
        {
            id: "rh-2",
            name: "Bien-Aime Baraza",
            ipi: "00654321987",
            type: "Writer",
            worksCount: 89,
            status: "Active",
            avatar: "person",
            email: "bien@solgeneration.org",
            phone: "+254 722 000 111",
            country: "Kenya",
        },
        {
            id: "rh-3",
            name: "Universal Music Africa",
            ipi: "12345678901",
            type: "Label",
            worksCount: 1240,
            status: "Active",
            avatar: "business",
            email: "legal@universalmusic.co.za",
            phone: "+27 11 000 2222",
            country: "South Africa",
        },
        {
            id: "rh-4",
            name: "Sol Generation",
            ipi: "09876543210",
            type: "Publisher",
            worksCount: 412,
            status: "Active",
            avatar: "business",
            email: "info@solgeneration.org",
            phone: "+254 733 444 555",
            country: "Kenya",
        },
    ];

    // Generate 200 holders deterministically
    let holders = $state(
        Array.from({ length: 200 }, (_, i) => {
            const base = baseHolders[i % baseHolders.length];
            return {
                ...base,
                id: `rh-${i}`,
                name:
                    i < baseHolders.length
                        ? base.name
                        : `${base.name} Studio ${i}`,
                ipi: (parseInt(base.ipi) + i).toString().padStart(11, "0"),
                worksCount: (10 + i * 3) % 500,
            };
        }),
    );

    // Filter & Search State
    let searchQuery = $state("");
    let filterType = $state("All");
    let filterStatus = $state("All");
    let currentPage = $state(1);
    const itemsPerPage = 25;

    const filteredHolders = $derived(
        holders.filter((h) => {
            const matchesSearch =
                h.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                h.ipi.toLowerCase().includes(searchQuery.toLowerCase());

            const matchesType = filterType === "All" || h.type === filterType;
            const matchesStatus =
                filterStatus === "All" || h.status === filterStatus;

            return matchesSearch && matchesType && matchesStatus;
        }),
    );

    const paginatedHolders = $derived(
        filteredHolders.slice(
            (currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage,
        ),
    );

    let types = [
        "All",
        "Writer",
        "Performer",
        "Label",
        "Publisher",
        "Producer",
    ];
    let statuses = ["All", "Active", "Inactive", "Pending"];

    function resetFilters() {
        searchQuery = "";
        filterType = "All";
        filterStatus = "All";
        currentPage = 1;
    }

    $effect(() => {
        if (searchQuery || filterType !== "All" || filterStatus !== "All") {
            currentPage = 1;
        }
    });

    // Interaction State
    let selectedHolderId = $state("");
    let isCreateOffcanvasOpen = $state(false);

    const selectedHolder = $derived(
        holders.find((h) => h.id === selectedHolderId),
    );

    function openDetails(id: string) {
        selectedHolderId = id;
    }

    function closeDetails() {
        selectedHolderId = "";
    }

    // Create Logic
    let newHolder = $state({
        name: "",
        ipi: "",
        type: "Writer",
        email: "",
        phone: "",
        country: "Kenya",
    });

    function handleAddHolder() {
        const id = `rh-${Date.now()}`;
        holders = [
            {
                ...newHolder,
                id,
                status: "Pending",
                worksCount: 0,
                avatar:
                    newHolder.type === "Label" || newHolder.type === "Publisher"
                        ? "business"
                        : "person",
            } as any,
            ...holders,
        ];

        isCreateOffcanvasOpen = false;
        selectedHolderId = id;

        // Reset form
        newHolder = {
            name: "",
            ipi: "",
            type: "Writer",
            email: "",
            phone: "",
            country: "Kenya",
        };
    }
</script>

<svelte:head>
    <title>Rights Holders | Spaza Airplay</title>
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
                            Rights Holders
                        </h1>
                        <p class="text-xs text-text-secondary font-medium">
                            Manage entities, IPI numbers, and distribution roles
                            across your catalog.
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
                        <div class="relative flex-1 w-full max-w-md">
                            <span
                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-base"
                                >search</span
                            >
                            <input
                                type="text"
                                placeholder="Search by name or IPI..."
                                class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-9 pr-4 text-xs text-white placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/40 focus:border-primary/40 transition-all"
                                bind:value={searchQuery}
                            />
                        </div>

                        <div class="flex items-center gap-2 w-full md:w-auto">
                            <div class="relative min-w-[130px]">
                                <select
                                    class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-3 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary hover:border-border-muted transition-colors appearance-none cursor-pointer"
                                    bind:value={filterType}
                                >
                                    {#each types as t}
                                        <option value={t}
                                            >{t === "All"
                                                ? "All Types"
                                                : t}</option
                                        >
                                    {/each}
                                </select>
                                <span
                                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-base text-text-muted pointer-events-none"
                                    >expand_more</span
                                >
                            </div>

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
                            >person_add</span
                        >
                        Add Rights Holder
                    </button>
                </div>
            </div>
        </div>

        <!-- Table Area -->
        <div class="flex-1 overflow-x-auto bg-surface-dark">
            <table class="w-full text-left border-collapse">
                <thead
                    class="bg-surface-dark border-b border-border-dark shadow-sm sticky top-0 z-10"
                >
                    <tr>
                        <th
                            class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                            >Holder Name</th
                        >
                        <th
                            class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                            >IPI Number</th
                        >
                        <th
                            class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                            >Primary Type</th
                        >
                        <th
                            class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary text-right"
                            >Linked Works</th
                        >
                        <th
                            class="py-4 px-6 text-[10px] font-bold uppercase tracking-widest text-text-secondary text-center"
                            >Status</th
                        >
                        <th class="py-4 px-6 w-10"></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-border-dark/50">
                    {#each paginatedHolders as holder (holder.id)}
                        <tr
                            class="table-row group relative cursor-pointer"
                            class:table-row-active={selectedHolderId ===
                                holder.id}
                            onclick={() => openDetails(holder.id)}
                        >
                            {#if selectedHolderId === holder.id}
                                <td
                                    class="absolute left-0 top-0 bottom-0 w-1 bg-primary"
                                ></td>
                            {/if}
                            <td class="py-4 px-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="size-9 rounded-full bg-surface-dark flex items-center justify-center text-text-secondary shrink-0 shadow-sm border border-border-dark"
                                    >
                                        <span
                                            class="material-symbols-outlined text-lg"
                                            >{holder.avatar}</span
                                        >
                                    </div>
                                    <p
                                        class="font-bold text-sm text-white tracking-tight group-hover:text-primary transition-colors"
                                    >
                                        {holder.name}
                                    </p>
                                </div>
                            </td>
                            <td
                                class="py-4 px-6 text-xs font-mono text-text-secondary tracking-tighter"
                                >{holder.ipi}</td
                            >
                            <td class="py-4 px-6">
                                <span
                                    class="px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest bg-surface-darker border border-border-dark text-text-secondary"
                                >
                                    {holder.type}
                                </span>
                            </td>
                            <td
                                class="py-4 px-6 text-right text-xs text-white font-medium"
                                >{holder.worksCount}</td
                            >
                            <td class="py-4 px-6 text-center">
                                <span
                                    class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-widest {holder.status ===
                                    'Active'
                                        ? 'bg-emerald-500/10 text-emerald-400'
                                        : 'bg-amber-500/10 text-amber-400'}"
                                >
                                    {holder.status}
                                </span>
                            </td>
                            <td class="py-4 px-6 text-right">
                                <button
                                    class="size-8 flex items-center justify-center rounded-lg text-text-muted hover:text-white hover:bg-surface-dark transition-all"
                                >
                                    <span
                                        class="material-symbols-outlined text-lg"
                                        >edit_note</span
                                    >
                                </button>
                            </td>
                        </tr>
                    {:else}
                        <tr>
                            <td colspan="6" class="py-20 text-center">
                                <div
                                    class="flex flex-col items-center gap-3 text-text-muted"
                                >
                                    <span
                                        class="material-symbols-outlined text-5xl opacity-20"
                                        >person_off</span
                                    >
                                    <p class="text-sm font-medium">
                                        No rights holders found
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

        <!-- Pagination Bar -->
        <div
            class="sticky bottom-0 bg-surface-darker/95 backdrop-blur-md border-t border-border-dark px-6 py-4 flex items-center justify-between z-20 shadow-[0_-10px_30px_rgba(0,0,0,0.3)]"
        >
            <p
                class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
            >
                Showing <span class="text-white">{paginatedHolders.length}</span
                >
                of <span class="text-white">{filteredHolders.length}</span> holders
            </p>
            <div class="flex items-center gap-6">
                <span
                    class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
                >
                    Page <span class="text-white">{currentPage}</span> / {Math.ceil(
                        filteredHolders.length / itemsPerPage,
                    ) || 1}
                </span>
                <div class="flex gap-2">
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-white hover:bg-primary/5 transition-all disabled:opacity-20"
                        onclick={() =>
                            (currentPage = Math.max(1, currentPage - 1))}
                        disabled={currentPage === 1}
                    >
                        <span class="material-symbols-outlined text-xl"
                            >chevron_left</span
                        >
                    </button>
                    <button
                        class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-white hover:bg-primary/5 transition-all disabled:opacity-20"
                        onclick={() =>
                            (currentPage = Math.min(
                                Math.ceil(
                                    filteredHolders.length / itemsPerPage,
                                ),
                                currentPage + 1,
                            ))}
                        disabled={currentPage ===
                            Math.ceil(filteredHolders.length / itemsPerPage) ||
                            filteredHolders.length === 0}
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
    {#if selectedHolder}
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
                        Holder Profile
                    </h2>
                    <p
                        class="text-[10px] text-text-muted uppercase tracking-widest mt-1 font-bold"
                    >
                        Registry Info
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
                        class="size-24 rounded-full bg-surface-dark flex items-center justify-center text-text-muted shadow-2xl border-2 border-border-dark"
                    >
                        <span class="material-symbols-outlined text-4xl"
                            >{selectedHolder.avatar}</span
                        >
                    </div>
                    <div class="mt-4 text-center">
                        <h3
                            class="text-2xl font-bold text-white tracking-tight leading-relaxed"
                        >
                            {selectedHolder.name}
                        </h3>
                        <p
                            class="text-primary font-bold text-sm tracking-wide uppercase mt-1"
                        >
                            {selectedHolder.type}
                        </p>
                    </div>
                </div>

                <div class="p-8 space-y-8">
                    <div class="grid grid-cols-2 gap-6">
                        <div class="space-y-1">
                            <p
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                            >
                                IPI Number
                            </p>
                            <p
                                class="text-sm font-mono text-white tracking-tighter"
                            >
                                {selectedHolder.ipi}
                            </p>
                        </div>
                        <div class="space-y-1">
                            <p
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                            >
                                Status
                            </p>
                            <span
                                class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-widest {selectedHolder.status ===
                                'Active'
                                    ? 'bg-emerald-500/10 text-emerald-400'
                                    : 'bg-amber-500/10 text-amber-400'}"
                            >
                                {selectedHolder.status}
                            </span>
                        </div>
                    </div>

                    <div class="space-y-4 pt-8 border-t border-border-dark/50">
                        <h4
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >
                            Contact Details
                        </h4>
                        <div class="space-y-3">
                            <div class="flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-text-muted text-sm"
                                    >mail</span
                                >
                                <span class="text-sm text-white"
                                    >{selectedHolder.email || "N/A"}</span
                                >
                            </div>
                            <div class="flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-text-muted text-sm"
                                    >call</span
                                >
                                <span class="text-sm text-white"
                                    >{selectedHolder.phone || "N/A"}</span
                                >
                            </div>
                            <div class="flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-text-muted text-sm"
                                    >public</span
                                >
                                <span class="text-sm text-white"
                                    >{selectedHolder.country || "N/A"}</span
                                >
                            </div>
                        </div>
                    </div>

                    <div class="space-y-4 pt-8 border-t border-border-dark/50">
                        <h4
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >
                            Summary Stats
                        </h4>
                        <div class="grid grid-cols-2 gap-3">
                            <div
                                class="p-4 bg-surface-darker rounded-xl border border-border-dark"
                            >
                                <p
                                    class="text-[10px] font-bold text-text-muted uppercase tracking-widest"
                                >
                                    Linked Works
                                </p>
                                <p class="text-xl font-bold text-white mt-1">
                                    {selectedHolder.worksCount}
                                </p>
                            </div>
                            <div
                                class="p-4 bg-surface-darker rounded-xl border border-border-dark"
                            >
                                <p
                                    class="text-[10px] font-bold text-text-muted uppercase tracking-widest"
                                >
                                    Share Avg.
                                </p>
                                <p class="text-xl font-bold text-white mt-1">
                                    12.5%
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </aside>
    {/if}

    <!-- Add Holder Offcanvas -->
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
                        Add Rights Holder
                    </h2>
                    <p class="text-xs text-text-secondary mt-1">
                        Register a new entity in the system.
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
                            for="holder-name">Full Name / Entity Name</label
                        >
                        <input
                            id="holder-name"
                            type="text"
                            placeholder="e.g., Sauti Sol"
                            class="input w-full"
                            bind:value={newHolder.name}
                        />
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="ipi">IPI Number</label
                            >
                            <input
                                id="ipi"
                                type="text"
                                placeholder="000.00.00.00"
                                class="input w-full font-mono text-xs"
                                bind:value={newHolder.ipi}
                            />
                        </div>
                        <div class="space-y-2">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="type">Primary Type</label
                            >
                            <select
                                id="type"
                                class="select w-full"
                                bind:value={newHolder.type}
                            >
                                {#each types.filter((t) => t !== "All") as t}
                                    <option value={t}>{t}</option>
                                {/each}
                            </select>
                        </div>
                    </div>

                    <div class="space-y-4 pt-4">
                        <h4
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >
                            Contact Information
                        </h4>
                        <div class="space-y-3">
                            <div class="space-y-2">
                                <label
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                    >Email Address</label
                                >
                                <input
                                    type="email"
                                    placeholder="email@example.com"
                                    class="input w-full"
                                    bind:value={newHolder.email}
                                />
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="space-y-2">
                                    <label
                                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                        >Phone</label
                                    >
                                    <input
                                        type="text"
                                        placeholder="+254"
                                        class="input w-full"
                                        bind:value={newHolder.phone}
                                    />
                                </div>
                                <div class="space-y-2">
                                    <label
                                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                        >Country</label
                                    >
                                    <input
                                        type="text"
                                        placeholder="Kenya"
                                        class="input w-full"
                                        bind:value={newHolder.country}
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 backdrop-blur-md"
            >
                <button
                    class="w-full btn btn-primary py-4 font-bold uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl shadow-primary/20"
                    disabled={!newHolder.name}
                    onclick={handleAddHolder}
                >
                    <span class="material-symbols-outlined">save</span>
                    Register Holder
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
