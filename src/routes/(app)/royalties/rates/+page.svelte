<script lang="ts">
    import { fly, fade, slide } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    // Mock Data based on rate_tables schema
    let rates = $state([
        {
            id: "rt-001",
            society_name: "MCSK",
            name: "Tier 1 Commercial Radio",
            source_type: "commercial_radio",
            calculation_method: "per_play",
            rate_amount: 50.0,
            revenue_percentage: null,
            effective_date: "2025-01-01",
            expiry_date: "2025-12-31",
            status: "active",
            rules: { min_play_duration: 30, premium_time_multiplier: 1.5 },
            currency: "KES",
        },
        {
            id: "rt-002",
            society_name: "KAMP",
            name: "Standard Club License",
            source_type: "club",
            calculation_method: "flat_fee",
            rate_amount: 15000.0,
            revenue_percentage: null,
            effective_date: "2025-01-01",
            expiry_date: null,
            status: "active",
            rules: { billing_cycle: "monthly" },
            currency: "KES",
        },
        {
            id: "rt-003",
            society_name: "PRISK",
            name: "Public Space Background",
            source_type: "hotel",
            calculation_method: "scientific_distribution",
            rate_amount: null,
            revenue_percentage: 2.5,
            effective_date: "2024-06-01",
            expiry_date: null,
            status: "active",
            rules: { pro_rata_base: "total_detections" },
            currency: "KES",
        },
    ]);

    // Options from Schema
    const societies = [
        "All",
        "MCSK",
        "KAMP",
        "PRISK",
        "UPRS",
        "COSOTA",
        "SAMRO",
    ];
    const methods = [
        "per_play",
        "scientific_distribution",
        "general_distribution",
        "percentage_revenue",
        "flat_fee",
        "duration_based",
    ];
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

    // Filters
    let searchQuery = $state("");
    let filterSociety = $state("All");
    let filterMethod = $state("All");
    let filterSourceType = $state("All");

    // Derived filtered rates
    let filteredRates = $derived(
        rates.filter((r) => {
            const matchSearch =
                r.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                r.society_name
                    .toLowerCase()
                    .includes(searchQuery.toLowerCase());
            const matchSociety =
                filterSociety === "All" || r.society_name === filterSociety;
            const matchMethod =
                filterMethod === "All" || r.calculation_method === filterMethod;
            const matchSource =
                filterSourceType === "All" ||
                r.source_type === filterSourceType;

            return matchSearch && matchSociety && matchMethod && matchSource;
        }),
    );

    // Selection & Offcanvas State
    let selectedRateId = $state<string | null>(null);
    let isCreateOpen = $state(false);
    let isDetailOpen = $state(false);

    let selectedRate = $derived(rates.find((r) => r.id === selectedRateId));

    function openDetail(id: string) {
        selectedRateId = id;
        isDetailOpen = true;
    }

    function closeDetail() {
        isDetailOpen = false;
        setTimeout(() => (selectedRateId = null), 300);
    }

    // Create Form State
    let newRate = $state({
        name: "",
        society_name: "MCSK",
        source_type: "commercial_radio",
        calculation_method: "per_play",
        rate_amount: 0,
        revenue_percentage: 0,
        effective_date: new Date().toISOString().split("T")[0],
        currency: "KES",
    });

    function createRate() {
        const id = `rt-new-${Date.now()}`;
        rates = [
            {
                id,
                ...newRate,
                status: "active",
                expiry_date: null,
                rules: {},
            } as any,
            ...rates,
        ];
        isCreateOpen = false;
        resetForm();
    }

    function resetForm() {
        newRate = {
            name: "",
            society_name: "MCSK",
            source_type: "commercial_radio",
            calculation_method: "per_play",
            rate_amount: 0,
            revenue_percentage: 0,
            effective_date: new Date().toISOString().split("T")[0],
            currency: "KES",
        };
    }

    function formatEnum(t: string | undefined | null) {
        if (!t) return "N/A";
        return t
            .split("_")
            .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
            .join(" ");
    }

    function resetFilters() {
        searchQuery = "";
        filterSociety = "All";
        filterMethod = "All";
        filterSourceType = "All";
    }
</script>

<svelte:head>
    <title>Rates Engine | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <!-- Header -->
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-white/95 backdrop-blur-sm z-30 px-8 flex flex-col justify-center"
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
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                >Royalty Management</span
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Rates Engine</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-background-dark border border-border-dark flex items-center justify-center text-primary shadow-saas-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >account_balance_wallet</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-text-primary tracking-tight leading-none"
                    >
                        Royalty Rates Engine
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Configure and manage CMO calculation rules
                    </p>
                </div>
            </div>

            <button
                class="h-9 px-4 btn-primary rounded-md flex items-center gap-2 shadow-saas-sm transition-all font-bold uppercase tracking-widest text-[10px]"
                onclick={() => (isCreateOpen = true)}
            >
                <span class="material-symbols-outlined text-lg">add_circle</span
                >
                New Rule
            </button>
        </div>
    </header>

    <!-- Filters Bar -->
    <div
        class="h-14 shrink-0 border-b border-border-dark bg-white/50 px-8 flex items-center gap-4 z-20 overflow-x-auto scrollbar-none"
    >
        <!-- Search -->
        <div class="relative group min-w-[240px]">
            <span
                class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-text-muted text-lg"
                >search</span
            >
            <input
                type="text"
                placeholder="Search rule or society..."
                class="h-8 w-full bg-background-dark border border-border-dark rounded-md pl-9 pr-4 text-xs text-text-primary placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary focus:border-primary transition-all font-medium"
                bind:value={searchQuery}
            />
        </div>

        <div class="h-6 w-px bg-border-dark mx-2"></div>

        <div class="flex items-center gap-3">
            <!-- Society Filter -->
            <div class="relative group">
                <select
                    class="h-8 w-36 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterSociety}
                >
                    {#each societies as s}
                        <option value={s}
                            >{s === "All" ? "All Societies" : s}</option
                        >
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >account_balance</span
                >
            </div>

            <!-- Method Filter -->
            <div class="relative group">
                <select
                    class="h-8 w-40 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterMethod}
                >
                    <option value="All">All Methods</option>
                    {#each methods as m}
                        <option value={m}>{formatEnum(m)}</option>
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >functions</span
                >
            </div>

            <!-- Source Type Filter -->
            <div class="relative group">
                <select
                    class="h-8 w-40 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterSourceType}
                >
                    <option value="All">All Source Types</option>
                    {#each sourceTypes as t}
                        <option value={t}>{formatEnum(t)}</option>
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >sensors</span
                >
            </div>
        </div>

        {#if searchQuery || filterSociety !== "All" || filterMethod !== "All" || filterSourceType !== "All"}
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
            <thead class="sticky top-0 z-10 bg-background-dark shadow-sm">
                <tr>
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[12%]"
                        >Society</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[25%]"
                        >Rule Name</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Source Type</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[18%]"
                        >Calculation Method</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Rate Value</th
                    >
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark text-right w-[15%]"
                        >Effective Date</th
                    >
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark/50 bg-white">
                {#each filteredRates as rate}
                    <tr
                        class="group hover:bg-background-dark transition-colors cursor-pointer"
                        onclick={() => openDetail(rate.id)}
                    >
                        <td class="py-4 px-8">
                            <span
                                class="px-2 py-0.5 rounded border border-border-dark bg-background-dark text-[10px] font-bold text-text-secondary"
                            >
                                {rate.society_name}
                            </span>
                        </td>
                        <td class="py-4 px-4">
                            <div
                                class="text-sm font-semibold text-text-primary group-hover:text-primary transition-colors"
                            >
                                {rate.name}
                            </div>
                        </td>
                        <td
                            class="py-4 px-4 text-xs text-text-secondary font-medium uppercase tracking-wider"
                        >
                            {formatEnum(rate.source_type)}
                        </td>
                        <td class="py-4 px-4">
                            <div class="flex items-center gap-2">
                                <span
                                    class="material-symbols-outlined text-base text-text-muted"
                                >
                                    {rate.calculation_method === "per_play"
                                        ? "pin"
                                        : rate.calculation_method === "flat_fee"
                                          ? "payments"
                                          : "rebase"}
                                </span>
                                <span
                                    class="text-xs text-text-secondary font-medium"
                                    >{formatEnum(rate.calculation_method)}</span
                                >
                            </div>
                        </td>
                        <td class="py-4 px-4">
                            {#if rate.rate_amount}
                                <span
                                    class="text-xs font-mono font-bold text-emerald-400"
                                    >{rate.currency}
                                    {rate.rate_amount.toLocaleString(
                                        undefined,
                                        { minimumFractionDigits: 2 },
                                    )}</span
                                >
                            {:else if rate.revenue_percentage}
                                <span
                                    class="text-xs font-mono font-bold text-amber-400"
                                    >{rate.revenue_percentage}% Revenue</span
                                >
                            {:else}
                                <span class="text-xs text-text-muted italic"
                                    >Variable</span
                                >
                            {/if}
                        </td>
                        <td
                            class="py-4 px-8 text-right text-xs font-mono text-text-muted"
                        >
                            {new Date(rate.effective_date).toLocaleDateString()}
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
                                    >schema</span
                                >
                                <p class="text-sm font-medium">
                                    No calculation rules found matching criteria
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

    <!-- Footer Stats -->
    <footer
        class="h-10 shrink-0 border-t border-border-dark bg-white px-8 flex items-center justify-between text-[10px] font-mono text-text-muted uppercase tracking-widest"
    >
        <div>Total Active Rules: {filteredRates.length}</div>
        <div class="flex gap-4">
            <span class="flex items-center gap-1.5"
                ><span class="size-1.5 bg-emerald-500 rounded-full"></span> Fixed
                Rate</span
            >
            <span class="flex items-center gap-1.5"
                ><span class="size-1.5 bg-amber-500 rounded-full"></span> Variable
                distribution</span
            >
        </div>
    </footer>

    <!-- Create Rate Offcanvas -->
    {#if isCreateOpen}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isCreateOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[500px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <div
                class="p-6 border-b border-border-dark bg-surface-dark relative"
            >
                <div class="flex justify-between items-start mb-1">
                    <h2 class="text-xl font-bold text-text-main tracking-tight">
                        New Calculation Rule
                    </h2>
                    <button
                        class="size-8 flex items-center justify-center rounded-lg hover:bg-surface-darker text-text-muted hover:text-text-main transition-colors"
                        onclick={() => (isCreateOpen = false)}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
                <p
                    class="text-[10px] text-text-muted font-medium uppercase tracking-widest"
                >
                    System Rule Builder v2.0
                </p>
            </div>

            <div class="flex-1 overflow-y-auto p-8 space-y-6">
                <!-- Basic Info -->
                <div class="space-y-4">
                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Rule Description</label
                        >
                        <input
                            type="text"
                            class="input w-full"
                            placeholder="e.g. Primetime Radio Play Coefficient"
                            bind:value={newRate.name}
                        />
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Society (CMO)</label
                            >
                            <select
                                class="select w-full"
                                bind:value={newRate.society_name}
                            >
                                {#each societies.filter((s) => s !== "All") as s}
                                    <option value={s}>{s}</option>
                                {/each}
                            </select>
                        </div>
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Currency</label
                            >
                            <select
                                class="select w-full"
                                bind:value={newRate.currency}
                            >
                                <option value="KES"
                                    >KES - Kenyan Shilling</option
                                >
                                <option value="UGX"
                                    >UGX - Ugandan Shilling</option
                                >
                                <option value="USD">USD - US Dollar</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Logic Setup -->
                <div class="pt-6 border-t border-border-dark space-y-4">
                    <h3
                        class="text-xs font-bold text-text-main uppercase tracking-widest"
                    >
                        Calculation Logic
                    </h3>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Applicable Source Type</label
                        >
                        <select
                            class="select w-full"
                            bind:value={newRate.source_type}
                        >
                            {#each sourceTypes as t}
                                <option value={t}>{formatEnum(t)}</option>
                            {/each}
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Method</label
                        >
                        <select
                            class="select w-full"
                            bind:value={newRate.calculation_method}
                        >
                            {#each methods as m}
                                <option value={m}>{formatEnum(m)}</option>
                            {/each}
                        </select>
                    </div>

                    <div class="grid grid-cols-2 gap-4 pt-2">
                        {#if newRate.calculation_method === "percentage_revenue"}
                            <div class="space-y-1.5 col-span-2">
                                <label
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                    >Revenue Percentage (%)</label
                                >
                                <div class="relative">
                                    <input
                                        type="number"
                                        step="0.01"
                                        class="input w-full pr-10"
                                        bind:value={newRate.revenue_percentage}
                                    />
                                    <span
                                        class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted font-bold"
                                        >%</span
                                    >
                                </div>
                            </div>
                        {:else}
                            <div class="space-y-1.5 col-span-2">
                                <label
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                    >Rate Amount</label
                                >
                                <div class="relative">
                                    <input
                                        type="number"
                                        step="0.01"
                                        class="input w-full pl-12"
                                        bind:value={newRate.rate_amount}
                                    />
                                    <span
                                        class="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-[10px] font-bold"
                                        >{newRate.currency}</span
                                    >
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>

                <!-- Timing -->
                <div class="pt-6 border-t border-border-dark space-y-4">
                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Effective Date</label
                        >
                        <input
                            type="date"
                            class="input w-full"
                            bind:value={newRate.effective_date}
                        />
                    </div>
                </div>
            </div>

            <div class="p-6 border-t border-border-dark bg-surface-darker/50">
                <button
                    class="w-full btn-primary py-4 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 transition-all flex items-center justify-center gap-2"
                    onclick={createRate}
                    disabled={!newRate.name}
                >
                    <span class="material-symbols-outlined">save</span>
                    Deploy Rate Table
                </button>
            </div>
        </aside>
    {/if}

    <!-- Detail/Edit Offcanvas -->
    {#if isDetailOpen && selectedRate}
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
            <div class="p-8 border-b border-border-dark bg-surface-darker/40">
                <div class="flex justify-between items-start mb-6">
                    <div>
                        <span
                            class="px-2 py-0.5 rounded-full border border-border-dark bg-surface-darker text-[9px] font-bold uppercase tracking-widest text-primary"
                        >
                            {selectedRate.society_name} Authority
                        </span>
                        <h2
                            class="text-2xl font-bold text-text-main tracking-tight mt-3"
                        >
                            {selectedRate.name}
                        </h2>
                        <p
                            class="text-[10px] text-text-muted font-bold uppercase tracking-tighter mt-1"
                        >
                            Rule ID: {selectedRate.id}
                        </p>
                    </div>
                    <button
                        class="size-9 flex items-center justify-center rounded-xl bg-surface-darker border border-border-dark text-text-muted hover:text-text-main transition-all shadow-sm"
                        onclick={closeDetail}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <div class="grid grid-cols-3 gap-3">
                    <div
                        class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Status</span
                        >
                        <div class="flex items-center gap-1.5">
                            <span
                                class="size-1.5 rounded-full bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]"
                            ></span>
                            <span
                                class="text-xs font-bold text-text-main uppercase"
                                >Active</span
                            >
                        </div>
                    </div>
                    <div
                        class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Method</span
                        >
                        <span
                            class="text-xs font-bold text-text-main uppercase truncate block"
                            >{formatEnum(selectedRate.calculation_method)}</span
                        >
                    </div>
                    <div
                        class="p-4 rounded-xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Effective</span
                        >
                        <span class="text-xs font-mono font-bold text-text-main"
                            >{selectedRate.effective_date}</span
                        >
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="flex-1 overflow-y-auto p-8 space-y-8">
                <!-- Rate Logic -->
                <section class="space-y-4">
                    <h3
                        class="text-xs font-bold text-text-main uppercase tracking-widest flex items-center gap-2"
                    >
                        <span class="material-symbols-outlined text-base"
                            >analytics</span
                        >
                        Valuation Parameters
                    </h3>
                    <div
                        class="p-6 rounded-2xl bg-surface-darker border border-border-dark space-y-4"
                    >
                        <div class="flex justify-between items-center py-2">
                            <span
                                class="text-xs text-text-secondary font-medium uppercase tracking-wider"
                                >Base Rate</span
                            >
                            {#if selectedRate.rate_amount}
                                <span
                                    class="text-lg font-mono font-bold text-emerald-400"
                                    >{selectedRate.currency}
                                    {selectedRate.rate_amount.toFixed(2)}</span
                                >
                            {:else}
                                <span
                                    class="text-lg font-mono font-bold text-amber-400"
                                    >{selectedRate.revenue_percentage}% Revenue</span
                                >
                            {/if}
                        </div>
                        <div class="h-px bg-border-dark/50"></div>
                        <div class="flex justify-between items-center py-2">
                            <span
                                class="text-xs text-text-secondary font-medium uppercase tracking-wider"
                                >Source Applicability</span
                            >
                            <span
                                class="text-xs font-bold text-text-main uppercase tracking-widest"
                                >{formatEnum(selectedRate.source_type)}</span
                            >
                        </div>
                    </div>
                </section>

                <!-- Rules Engine (JSON Editor Preview) -->
                <section class="space-y-4">
                    <div class="flex items-center justify-between">
                        <h3
                            class="text-xs font-bold text-text-main uppercase tracking-widest flex items-center gap-2"
                        >
                            <span class="material-symbols-outlined text-base"
                                >rule</span
                            >
                            Advanced Rules Engine
                        </h3>
                        <button
                            class="text-[10px] text-primary font-bold uppercase tracking-widest hover:underline"
                            >Edit Logic</button
                        >
                    </div>

                    <div
                        class="rounded-xl bg-background-dark/80 border border-border-dark p-4 font-mono text-[11px] leading-relaxed"
                    >
                        <div class="text-text-muted">{"{"}</div>
                        {#each Object.entries(selectedRate.rules) as [key, value]}
                            <div class="pl-4">
                                <span class="text-primary">"{key}"</span>:
                                <span class="text-amber-400"
                                    >{typeof value === "string"
                                        ? `"${value}"`
                                        : value}</span
                                >,
                            </div>
                        {/each}
                        <div class="pl-4">
                            <span class="text-primary">"created_at"</span>:
                            <span class="text-amber-400"
                                >"2026-02-04T18:20:00Z"</span
                            >
                        </div>
                        <div class="text-text-muted">{"}"}</div>
                    </div>
                </section>

                <!-- Audit History -->
                <section class="space-y-4">
                    <h3
                        class="text-xs font-bold text-text-main uppercase tracking-widest flex items-center gap-2"
                    >
                        <span class="material-symbols-outlined text-base"
                            >history</span
                        >
                        Version History
                    </h3>
                    <div
                        class="border border-border-dark rounded-xl divide-y divide-border-dark/50 overflow-hidden"
                    >
                        <div
                            class="p-4 bg-surface-darker flex items-center justify-between text-[11px]"
                        >
                            <div class="flex items-center gap-3">
                                <div
                                    class="size-1.5 rounded-full bg-emerald-500"
                                ></div>
                                <span class="text-text-main font-medium"
                                    >Initial Deploy</span
                                >
                            </div>
                            <span class="text-text-muted font-mono"
                                >{selectedRate.effective_date}</span
                            >
                        </div>
                        <div
                            class="p-4 bg-surface-darker flex items-center justify-center text-[10px] text-text-muted italic py-6"
                        >
                            No previous versions found for this rule.
                        </div>
                    </div>
                </section>
            </div>

            <!-- Action Bar -->
            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 flex gap-3"
            >
                <button
                    class="flex-1 h-12 rounded-xl border border-border-dark bg-surface-dark text-text-main text-[10px] font-bold uppercase tracking-widest hover:bg-surface-darker transition-all flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg"
                        >archive</span
                    >
                    Archive Rule
                </button>
                <button
                    class="flex-1 h-12 rounded-xl btn-primary text-[10px] font-bold uppercase tracking-widest shadow-lg shadow-primary/20 flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg"
                        >edit_note</span
                    >
                    Update Configuration
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
    .input {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: #10b981;
        box-shadow: 0 0 0 1px rgba(16, 185, 129, 0.2);
    }
    .select {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 2.5rem;
        color: #0f172a;
        font-size: 0.875rem;
        font-weight: 500;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(71, 85, 105, 1)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 0.75rem center;
        background-size: 1.25rem;
        cursor: pointer;
    }

    /* Hide scrollbar */
    .scrollbar-none::-webkit-scrollbar {
        display: none;
    }
    .scrollbar-none {
        -ms-overflow-style: none;
        scrollbar-width: none;
    }
</style>
