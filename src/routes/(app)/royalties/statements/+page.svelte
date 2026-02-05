<script lang="ts">
    import { fly, fade, slide } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    import type { PageData } from "./$types";
    let { data }: { data: PageData } = $props();

    // statements from Supabase
    let statements = $state(data.statements || []);

    $effect(() => {
        if (data.statements) {
            statements = data.statements;
        }
    });

    // Filter State
    let searchQuery = $state("");
    let filterSociety = $state("All");
    let filterStatus = $state("All");

    const societies = ["All", "MCSK", "KAMP", "PRISK", "SAMRO", "UPRS"];
    const statuses = ["All", "draft", "approved", "paid"];

    const filteredStatements = $derived(
        statements.filter((s) => {
            const matchesSearch =
                s.rights_holder
                    .toLowerCase()
                    .includes(searchQuery.toLowerCase()) ||
                s.society_name
                    .toLowerCase()
                    .includes(searchQuery.toLowerCase()) ||
                s.id.toLowerCase().includes(searchQuery.toLowerCase());
            const matchesSociety =
                filterSociety === "All" || s.society_name === filterSociety;
            const matchesStatus =
                filterStatus === "All" || s.status === filterStatus;
            return matchesSearch && matchesSociety && matchesStatus;
        }),
    );

    // Offcanvas State
    let isWizardOpen = $state(false);
    let selectedStatementId = $state<string | null>(null);
    let isDetailOpen = $state(false);

    const selectedStatement = $derived(
        statements.find((s) => s.id === selectedStatementId),
    );

    function openDetail(id: string) {
        selectedStatementId = id;
        isDetailOpen = true;
    }

    function closeDetail() {
        isDetailOpen = false;
        setTimeout(() => (selectedStatementId = null), 300);
    }

    // Wizard Form
    let wizardForm = $state({
        period: "Monthly",
        month: "January 2026",
        society: "MCSK",
        criteria: "Scientific Distribution",
    });

    function handleRunWizard() {
        // Mock triggering process
        isWizardOpen = false;
        // Normally would trigger an API call and show progress
    }

    function resetFilters() {
        searchQuery = "";
        filterSociety = "All";
        filterStatus = "All";
    }
</script>

<svelte:head>
    <title>Statements | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <!-- Header -->
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
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                >Royalties</span
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Statements History</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-surface-darker border border-border-dark flex items-center justify-center text-primary shadow-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >description</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-text-main tracking-tight leading-none"
                    >
                        Distribution Statements
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Review and manage generated royalty payouts
                    </p>
                </div>
            </div>

            <button
                class="h-9 px-4 btn-primary rounded-lg flex items-center gap-2 shadow-lg shadow-primary/10 hover:shadow-primary/20 transition-all font-bold uppercase tracking-widest text-[10px]"
                onclick={() => (isWizardOpen = true)}
            >
                <span class="material-symbols-outlined text-lg"
                    >play_circle</span
                >
                Run Distribution Wizard
            </button>
        </div>
    </header>

    <!-- Filters Bar -->
    <div
        class="h-14 shrink-0 border-b border-border-dark bg-surface-dark/50 px-8 flex items-center gap-4 z-20"
    >
        <div class="relative min-w-[300px]">
            <span
                class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-text-muted text-lg"
                >search</span
            >
            <input
                type="text"
                placeholder="Search by ID, Holder or CMO..."
                class="h-8 w-full bg-surface-darker border border-border-dark rounded-md pl-9 pr-4 text-xs text-text-main placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/50 transition-all font-medium"
                bind:value={searchQuery}
            />
        </div>

        <div class="h-6 w-px bg-border-dark mx-2"></div>

        <div class="flex items-center gap-3">
            <select
                class="h-8 w-32 bg-surface-darker border border-border-dark rounded-md px-2 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer"
                bind:value={filterSociety}
            >
                {#each societies as s}
                    <option value={s}>{s === "All" ? "All CMOs" : s}</option>
                {/each}
            </select>

            <select
                class="h-8 w-32 bg-surface-darker border border-border-dark rounded-md px-2 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer"
                bind:value={filterStatus}
            >
                {#each statuses as st}
                    <option value={st}
                        >{st === "All"
                            ? "All Status"
                            : st.toUpperCase()}</option
                    >
                {/each}
            </select>
        </div>

        {#if searchQuery || filterSociety !== "All" || filterStatus !== "All"}
            <button
                class="ml-auto text-[10px] text-primary font-bold uppercase tracking-widest hover:underline transition-all"
                onclick={resetFilters}
            >
                Clear Filters
            </button>
        {/if}
    </div>

    <!-- Main Table Area -->
    <main class="flex-1 overflow-auto relative">
        <table class="w-full text-left border-collapse">
            <thead class="sticky top-0 z-10 bg-surface-dark shadow-sm">
                <tr>
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >ID & Date</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[20%]"
                        >Rights Holder</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[10%]"
                        >Society</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Period</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[15%]"
                        >Total Amount</th
                    >
                    <th
                        class="py-3 px-4 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark w-[10%]"
                        >Status</th
                    >
                    <th
                        class="py-3 px-8 text-[10px] font-bold uppercase tracking-widest text-text-muted border-b border-border-dark text-right w-[15%]"
                        >Actions</th
                    >
                </tr>
            </thead>
            <tbody class="divide-y divide-border-dark/30">
                {#each filteredStatements as stmt}
                    <tr
                        class="group hover:bg-surface-darker/50 transition-colors cursor-pointer"
                        onclick={() => openDetail(stmt.id)}
                    >
                        <td class="py-4 px-8">
                            <div
                                class="text-[11px] font-mono font-bold text-text-muted"
                            >
                                #{stmt.id}
                            </div>
                            <div class="text-[10px] text-text-muted mt-0.5">
                                {new Date(
                                    stmt.generated_at,
                                ).toLocaleDateString()}
                            </div>
                        </td>
                        <td
                            class="py-4 px-4 font-semibold text-text-main group-hover:text-primary transition-colors"
                        >
                            {stmt.rights_holder}
                        </td>
                        <td class="py-4 px-4">
                            <span
                                class="px-2 py-0.5 rounded border border-border-dark bg-surface-darker text-[9px] font-bold text-text-secondary"
                            >
                                {stmt.society_name}
                            </span>
                        </td>
                        <td
                            class="py-4 px-4 text-xs text-text-secondary font-medium uppercase tracking-wider"
                        >
                            {new Date(stmt.period_start).toLocaleDateString(
                                "en-US",
                                { month: "short" },
                            )} - {new Date(stmt.period_end).toLocaleDateString(
                                "en-US",
                                { month: "short", year: "2-digit" },
                            )}
                        </td>
                        <td class="py-4 px-4">
                            <span
                                class="text-xs font-mono font-bold text-emerald-400"
                                >{stmt.currency}
                                {stmt.total_amount.toLocaleString(undefined, {
                                    minimumFractionDigits: 2,
                                })}</span
                            >
                        </td>
                        <td class="py-4 px-4">
                            <div class="flex items-center gap-1.5">
                                <span
                                    class="size-1.5 rounded-full {stmt.status ===
                                    'paid'
                                        ? 'bg-emerald-500'
                                        : stmt.status === 'approved'
                                          ? 'bg-blue-500'
                                          : 'bg-amber-500'}"
                                ></span>
                                <span
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                                    >{stmt.status}</span
                                >
                            </div>
                        </td>
                        <td class="py-4 px-8 text-right">
                            <button
                                class="size-8 rounded-lg bg-surface-dark border border-border-dark text-text-muted hover:text-text-main transition-all inline-flex items-center justify-center"
                                onclick={(e) => {
                                    e.stopPropagation();
                                }}
                            >
                                <span class="material-symbols-outlined text-lg"
                                    >download</span
                                >
                            </button>
                        </td>
                    </tr>
                {:else}
                    <tr>
                        <td colspan="7" class="py-32 text-center">
                            <div
                                class="flex flex-col items-center justify-center opacity-30"
                            >
                                <span
                                    class="material-symbols-outlined text-5xl mb-3"
                                    >description</span
                                >
                                <p class="text-sm font-medium">
                                    No royalty statements matches your search
                                    criteria
                                </p>
                            </div>
                        </td>
                    </tr>
                {/each}
            </tbody>
        </table>
    </main>

    <!-- Wizard Offcanvas -->
    {#if isWizardOpen}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isWizardOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[480px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <div class="p-6 border-b border-border-dark bg-surface-darker/50">
                <div class="flex justify-between items-start">
                    <div>
                        <h2
                            class="text-xl font-bold text-text-main tracking-tight text-glow"
                        >
                            Distribution Wizard
                        </h2>
                        <p
                            class="text-[10px] text-text-muted font-bold uppercase tracking-widest mt-1"
                        >
                            Automated Royalty Calculation Engine
                        </p>
                    </div>
                    <button
                        class="size-9 flex items-center justify-center rounded-xl bg-surface-dark border border-border-dark text-text-muted hover:text-text-main transition-all shadow-sm"
                        onclick={() => (isWizardOpen = false)}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
            </div>

            <div class="flex-1 overflow-y-auto p-8 space-y-8">
                <div class="space-y-6">
                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Selection Period</label
                        >
                        <select
                            class="select w-full"
                            bind:value={wizardForm.period}
                        >
                            <option>Monthly</option>
                            <option>Quarterly</option>
                            <option>Custom Range</option>
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Target Month / Quarter</label
                        >
                        <input type="month" class="input w-full" />
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Authority (CMO)</label
                        >
                        <select
                            class="select w-full"
                            bind:value={wizardForm.society}
                        >
                            {#each societies.filter((s) => s !== "All") as s}
                                <option value={s}>{s}</option>
                            {/each}
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Distribution Criteria</label
                        >
                        <select
                            class="select w-full"
                            bind:value={wizardForm.criteria}
                        >
                            <option
                                >Scientific Distribution (Exact Matches)</option
                            >
                            <option>General Distribution (Fixed pool)</option>
                            <option>Venue Specific Pool</option>
                        </select>
                    </div>
                </div>

                <div
                    class="p-6 rounded-2xl bg-surface-darker border border-border-dark space-y-3"
                >
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined text-primary"
                            >info</span
                        >
                        <h4
                            class="text-xs font-bold text-text-main uppercase tracking-widest"
                        >
                            Logic Insight
                        </h4>
                    </div>
                    <p class="text-[11px] text-text-muted leading-relaxed">
                        This process will scan over <strong
                            >1.2M detections</strong
                        >
                        for the selected period and calculate earnings based on configured
                        <strong>Rate Tables</strong>
                        for {wizardForm.society}.
                    </p>
                </div>
            </div>

            <div class="p-6 border-t border-border-dark bg-surface-darker/50">
                <button
                    class="w-full btn-primary py-4 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 transition-all flex items-center justify-center gap-2"
                    onclick={handleRunWizard}
                >
                    <span class="material-symbols-outlined text-xl"
                        >rocket_launch</span
                    >
                    Initialize Calculation
                </button>
            </div>
        </aside>
    {/if}

    <!-- Details Offcanvas -->
    {#if isDetailOpen && selectedStatement}
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
            <!-- Hero Header -->
            <div
                class="h-48 shrink-0 relative bg-surface-darker overflow-hidden"
            >
                <div
                    class="absolute inset-0 opacity-10 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:24px_24px]"
                ></div>
                <div
                    class="absolute inset-0 bg-gradient-to-t from-surface-darker via-transparent to-transparent"
                ></div>

                <div class="absolute top-6 right-6 z-10">
                    <button
                        class="size-9 rounded-full bg-black/40 hover:bg-black/60 backdrop-blur text-text-main flex items-center justify-center transition-all"
                        onclick={closeDetail}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <div
                    class="absolute bottom-0 left-0 right-0 p-8 flex items-end gap-6"
                >
                    <div
                        class="size-20 rounded-2xl bg-surface-dark border border-border-dark flex items-center justify-center text-3xl font-black text-primary shadow-2xl transform -rotate-3"
                    >
                        <span class="material-symbols-outlined text-4xl"
                            >payments</span
                        >
                    </div>
                    <div class="flex-1 mb-1">
                        <div class="flex items-center gap-3">
                            <h2
                                class="text-2xl font-black text-text-main tracking-tighter"
                            >
                                {selectedStatement.rights_holder}
                            </h2>
                            <span
                                class="px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest bg-emerald-500/10 text-emerald-400 border border-emerald-500/20"
                            >
                                {selectedStatement.status}
                            </span>
                        </div>
                        <p
                            class="text-[10px] text-text-muted font-bold uppercase tracking-widest mt-1 opacity-70"
                        >
                            Ref: {selectedStatement.id} &bull; {selectedStatement.society_name}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Summary Stats -->
            <div
                class="p-8 grid grid-cols-3 gap-3 border-b border-border-dark bg-background-dark/30"
            >
                <div
                    class="p-4 rounded-xl bg-surface-darker/60 border border-border-dark/50 text-center"
                >
                    <span
                        class="text-[9px] font-bold text-text-muted uppercase block"
                        >Total Net</span
                    >
                    <span class="text-sm font-black text-emerald-400 font-mono"
                        >{selectedStatement.currency}
                        {selectedStatement.total_amount.toLocaleString()}</span
                    >
                </div>
                <div
                    class="p-4 rounded-xl bg-surface-darker/60 border border-border-dark/50 text-center"
                >
                    <span
                        class="text-[9px] font-bold text-text-muted uppercase block"
                        >Recordings</span
                    >
                    <span class="text-sm font-black text-text-main font-mono"
                        >{selectedStatement.details.length}</span
                    >
                </div>
                <div
                    class="p-4 rounded-xl bg-surface-darker/60 border border-border-dark/50 text-center"
                >
                    <span
                        class="text-[9px] font-bold text-text-muted uppercase block"
                        >Period</span
                    >
                    <span class="text-[10px] font-bold text-text-main uppercase"
                        >{new Date(
                            selectedStatement.period_start,
                        ).toLocaleDateString("en-US", {
                            month: "short",
                        })} - {new Date(
                            selectedStatement.period_end,
                        ).toLocaleDateString("en-US", {
                            month: "short",
                        })}</span
                    >
                </div>
            </div>

            <!-- Details Breakdown -->
            <div class="flex-1 overflow-y-auto p-8 space-y-6">
                <h3
                    class="text-xs font-bold text-text-main uppercase tracking-widest flex items-center gap-2"
                >
                    <span class="material-symbols-outlined text-base"
                        >format_list_bulleted</span
                    >
                    Line Item Breakdown
                </h3>

                <div class="space-y-3">
                    {#each selectedStatement.details as item}
                        <div
                            class="flex items-center justify-between p-4 bg-surface-darker/30 border border-border-dark rounded-xl group hover:border-primary/30 transition-all shadow-sm"
                        >
                            <div class="flex items-center gap-4">
                                <div
                                    class="size-10 rounded-lg bg-surface-dark flex items-center justify-center text-text-muted group-hover:text-primary"
                                >
                                    <span class="material-symbols-outlined"
                                        >music_note</span
                                    >
                                </div>
                                <div>
                                    <h4
                                        class="text-sm font-bold text-text-main transition-colors"
                                    >
                                        {item.recording}
                                    </h4>
                                    <p
                                        class="text-[11px] text-text-muted font-medium"
                                    >
                                        Detected {item.plays} times in broadcast
                                    </p>
                                </div>
                            </div>
                            <div class="text-right">
                                <span
                                    class="text-sm font-mono font-bold text-text-main"
                                    >{selectedStatement.currency}
                                    {item.amount.toLocaleString()}</span
                                >
                                <div
                                    class="text-[9px] font-bold uppercase text-text-muted mt-1"
                                >
                                    Calculated
                                </div>
                            </div>
                        </div>
                    {/each}
                </div>
            </div>

            <!-- Actions -->
            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 flex gap-3"
            >
                <button
                    class="flex-1 h-12 rounded-xl border border-border-dark bg-surface-dark text-text-main text-[10px] font-bold uppercase tracking-widest hover:bg-surface-darker transition-all flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg"
                        >download</span
                    >
                    PDF Export
                </button>
                <button
                    class="flex-1 h-12 rounded-xl btn-primary text-[10px] font-bold uppercase tracking-widest shadow-lg shadow-primary/20 flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg">send</span>
                    Send to Holder
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
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

    .text-glow {
        text-shadow: 0 0 10px rgba(16, 185, 129, 0.2);
    }
</style>
