<script lang="ts">
    // Mock Statements
    const statements = [
        {
            id: "stmt-2025-q4",
            period: "Q4 2025",
            society: "MCSK",
            amount: "KES 450,200.00",
            status: "Paid",
            date: "Jan 15, 2026",
        },
        {
            id: "stmt-2025-q3",
            period: "Q3 2025",
            society: "MCSK",
            amount: "KES 412,500.00",
            status: "Paid",
            date: "Oct 15, 2025",
        },
        {
            id: "stmt-2025-q4-kamp",
            period: "Q4 2025",
            society: "KAMP",
            amount: "KES 120,000.00",
            status: "Processing",
            date: "Pending",
        },
    ];
</script>

<svelte:head>
    <title>Statements | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full flex-col overflow-hidden -m-4 md:-m-8">
    <div
        class="px-8 py-6 border-b border-border-dark shrink-0 bg-surface-darker"
    >
        <div class="flex justify-between items-end">
            <div>
                <h1 class="text-3xl font-bold tracking-tight text-white">
                    Royalty Statements
                </h1>
                <p class="text-text-secondary mt-1">
                    Generate and download distribution reports.
                </p>
            </div>
            <button class="btn-primary">
                <span class="material-symbols-outlined">play_circle</span>
                Run Distribution Wizard
            </button>
        </div>
    </div>

    <div class="flex-1 overflow-auto bg-surface-dark p-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left: History List -->
            <div class="lg:col-span-2 space-y-4">
                <h3 class="font-bold text-white text-lg">Statement History</h3>
                <div class="flex flex-col gap-4">
                    {#each statements as stmt}
                        <div
                            class="card p-4 flex items-center justify-between group"
                        >
                            <div class="flex items-center gap-4">
                                <div
                                    class="size-10 rounded bg-surface-darker border border-border-dark flex items-center justify-center"
                                >
                                    <span
                                        class="material-symbols-outlined text-text-secondary"
                                        >description</span
                                    >
                                </div>
                                <div>
                                    <h4 class="font-bold text-white text-sm">
                                        {stmt.period} Distribution ({stmt.society})
                                    </h4>
                                    <p class="text-xs text-text-secondary">
                                        Generated: {stmt.date}
                                    </p>
                                </div>
                            </div>
                            <div class="flex items-center gap-6">
                                <span class="font-mono font-bold text-white"
                                    >{stmt.amount}</span
                                >
                                <span
                                    class="badge {stmt.status === 'Paid'
                                        ? 'badge-success'
                                        : 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20'} w-24 justify-center"
                                    >{stmt.status}</span
                                >
                                <button
                                    class="btn-secondary size-8 p-0 flex items-center justify-center"
                                >
                                    <span
                                        class="material-symbols-outlined text-[18px]"
                                        >download</span
                                    >
                                </button>
                            </div>
                        </div>
                    {/each}
                </div>
            </div>

            <!-- Right: Quick Actions / Wizard -->
            <div class="space-y-6">
                <div
                    class="card bg-gradient-to-br from-surface-darker to-surface-dark border-primary/20"
                >
                    <h3 class="font-bold text-white mb-2">
                        Generate New Statement
                    </h3>
                    <p class="text-sm text-text-secondary mb-4">
                        Calculate royalties for a specific period and society.
                    </p>

                    <div class="space-y-3">
                        <label class="block">
                            <span
                                class="text-xs font-bold text-text-secondary uppercase"
                                >Period</span
                            >
                            <select class="select w-full mt-1">
                                <option>Current Quarter (Q1 2026)</option>
                                <option>Last Month (Jan 2026)</option>
                            </select>
                        </label>
                        <label class="block">
                            <span
                                class="text-xs font-bold text-text-secondary uppercase"
                                >Society / Entity</span
                            >
                            <select class="select w-full mt-1">
                                <option>MCSK (Composers)</option>
                                <option>KAMP (Producers)</option>
                            </select>
                        </label>
                        <button class="btn-primary w-full mt-2">
                            Start Calculation
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
