<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    const logs = $derived(data?.logs ?? []);

    let selectedLogId = $state("");

    $effect(() => {
        if (!selectedLogId && logs.length > 0) {
            selectedLogId = logs[0].id;
        }
    });

    const selectedLog = $derived(
        logs.find((l: any) => l.id === selectedLogId) || logs[0] || {},
    );

    // Calculation breakdown data
    const calculation = {
        baseRate: 9.0,
        seconds: 225,
        ratePerSec: 0.04,
        multiplier: 1.5,
        multiplierReason: "UK Tier 1 Station",
        subtotal: 13.5,
        fees: 1.05,
        feePercent: 15,
        final: 12.45,
    };
</script>

<svelte:head>
    <title>Airplay Logs | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full overflow-hidden -m-4 md:-m-8">
    <!-- Left: Logs Table -->
    <main
        class="flex-1 flex flex-col min-w-0 bg-background-dark relative border-r border-border-dark"
    >
        <!-- Page Header -->
        <div class="px-8 pt-6 pb-2 shrink-0">
            <div class="flex flex-wrap gap-2 items-center mb-4">
                <a
                    class="text-text-secondary text-sm font-medium hover:text-white"
                    href="/dashboard">Dashboard</a
                >
                <span
                    class="material-symbols-outlined text-text-secondary text-sm"
                    >chevron_right</span
                >
                <span class="text-white text-sm font-medium"
                    >Airplay & Royalties</span
                >
            </div>
            <div class="flex flex-wrap justify-between items-end gap-4">
                <div class="flex flex-col gap-1">
                    <h1 class="text-white text-3xl font-black tracking-tight">
                        Airplay Logs
                    </h1>
                    <p class="text-text-secondary text-sm">
                        Detailed records of detected broadcasts and earnings
                        estimation.
                    </p>
                </div>
                <button class="btn-secondary">
                    <span class="material-symbols-outlined text-[18px]"
                        >download</span
                    >
                    <span class="truncate">Export Report</span>
                </button>
            </div>
        </div>

        <!-- Filters Toolbar -->
        <div
            class="px-8 py-4 shrink-0 grid grid-cols-1 md:grid-cols-4 gap-4 border-b border-border-dark/50"
        >
            <label class="flex flex-col gap-1.5">
                <span
                    class="text-xs font-semibold text-text-secondary uppercase tracking-wider"
                    >Date Range</span
                >
                <div class="relative">
                    <select class="select py-2 text-sm pr-10">
                        <option>Last 30 Days</option>
                        <option>This Quarter</option>
                        <option>Last Year</option>
                    </select>
                    <span
                        class="material-symbols-outlined absolute right-2.5 top-2 text-text-secondary pointer-events-none"
                        >calendar_today</span
                    >
                </div>
            </label>
            <label class="flex flex-col gap-1.5">
                <span
                    class="text-xs font-semibold text-text-secondary uppercase tracking-wider"
                    >Territory</span
                >
                <div class="relative">
                    <select class="select py-2 text-sm pr-10">
                        <option>Global (All)</option>
                        <option>North America</option>
                        <option>Europe</option>
                    </select>
                    <span
                        class="material-symbols-outlined absolute right-2.5 top-2 text-text-secondary pointer-events-none"
                        >public</span
                    >
                </div>
            </label>
            <label class="flex flex-col gap-1.5">
                <span
                    class="text-xs font-semibold text-text-secondary uppercase tracking-wider"
                    >Tier</span
                >
                <div class="relative">
                    <select class="select py-2 text-sm pr-10">
                        <option>All Tiers</option>
                        <option>Tier 1 (National)</option>
                        <option>Tier 2 (Regional)</option>
                    </select>
                    <span
                        class="material-symbols-outlined absolute right-2.5 top-2 text-text-secondary pointer-events-none"
                        >filter_list</span
                    >
                </div>
            </label>
            <label class="flex flex-col gap-1.5">
                <span
                    class="text-xs font-semibold text-text-secondary uppercase tracking-wider"
                    >Filter Song</span
                >
                <input
                    class="input py-2 text-sm"
                    placeholder="Filter by title..."
                />
            </label>
        </div>

        <!-- Table -->
        <div class="flex-1 overflow-auto px-8 pb-8">
            <table class="w-full text-left border-collapse">
                <thead
                    class="sticky top-0 bg-background-dark z-10 shadow-[0_1px_0_0_rgba(40,57,51,1)]"
                >
                    <tr>
                        <th
                            class="py-4 pr-4 text-xs font-semibold text-text-secondary uppercase tracking-wider w-[180px]"
                            >Timestamp</th
                        >
                        <th
                            class="py-4 px-4 text-xs font-semibold text-text-secondary uppercase tracking-wider"
                            >Song Title</th
                        >
                        <th
                            class="py-4 px-4 text-xs font-semibold text-text-secondary uppercase tracking-wider"
                            >Broadcaster</th
                        >
                        <th
                            class="py-4 px-4 text-xs font-semibold text-text-secondary uppercase tracking-wider"
                            >Duration</th
                        >
                        <th
                            class="py-4 px-4 text-xs font-semibold text-text-secondary uppercase tracking-wider text-right"
                            >Est. Royalty</th
                        >
                        <th
                            class="py-4 pl-4 text-xs font-semibold text-text-secondary uppercase tracking-wider w-[50px]"
                        ></th>
                    </tr>
                </thead>
                <tbody class="text-sm divide-y divide-border-dark">
                    {#each logs as log}
                        <tr
                            class="table-row group"
                            class:table-row-active={selectedLogId === log.id}
                            onclick={() => (selectedLogId = log.id)}
                        >
                            <td class="py-4 pr-4 text-text-secondary pl-3"
                                >{log.timestamp}</td
                            >
                            <td class="py-4 px-4 font-bold text-white">
                                <div class="flex items-center gap-3">
                                    <div
                                        class="size-8 rounded bg-surface-dark flex items-center justify-center"
                                    >
                                        <span
                                            class="material-symbols-outlined text-lg"
                                            >music_note</span
                                        >
                                    </div>
                                    {log.song}
                                </div>
                            </td>
                            <td class="py-4 px-4">
                                <div class="flex items-center gap-2">
                                    <span class="text-lg leading-none"
                                        >{log.country}</span
                                    >
                                    <span>{log.broadcaster}</span>
                                    <span
                                        class="px-1.5 py-0.5 rounded bg-border-dark text-[10px] text-text-secondary font-bold uppercase tracking-wider ml-1"
                                        >{log.tier}</span
                                    >
                                </div>
                            </td>
                            <td class="py-4 px-4 text-text-secondary"
                                >{log.duration}</td
                            >
                            <td
                                class="py-4 px-4 text-right font-bold"
                                class:text-primary={selectedLogId === log.id}
                            >
                                ${log.royalty.toFixed(2)}
                            </td>
                            <td class="py-4 pl-4 text-center">
                                <span
                                    class="material-symbols-outlined text-primary text-[20px]"
                                    >chevron_right</span
                                >
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div
            class="px-8 py-4 border-t border-border-dark flex justify-between items-center bg-background-dark"
        >
            <p class="text-sm text-text-secondary">Showing 1-5 of 1,248 logs</p>
            <div class="flex gap-2">
                <button
                    class="size-8 flex items-center justify-center rounded-lg bg-surface-dark border border-border-dark text-text-secondary hover:text-white hover:bg-border-dark transition-colors disabled:opacity-50"
                >
                    <span class="material-symbols-outlined">chevron_left</span>
                </button>
                <button
                    class="size-8 flex items-center justify-center rounded-lg bg-primary text-background-dark font-bold"
                    >1</button
                >
                <button
                    class="size-8 flex items-center justify-center rounded-lg bg-surface-dark border border-border-dark text-text-secondary hover:text-white hover:bg-border-dark transition-colors"
                    >2</button
                >
                <button
                    class="size-8 flex items-center justify-center rounded-lg bg-surface-dark border border-border-dark text-text-secondary hover:text-white hover:bg-border-dark transition-colors"
                >
                    <span class="material-symbols-outlined">chevron_right</span>
                </button>
            </div>
        </div>
    </main>

    <!-- Right: Inspector -->
    <aside
        class="w-[400px] bg-surface-darker border-l border-border-dark flex flex-col h-full overflow-auto shrink-0 shadow-xl z-20"
    >
        <div
            class="p-6 border-b border-border-dark flex justify-between items-start"
        >
            <h3 class="text-white font-bold text-lg">Royalty Breakdown</h3>
            <button
                class="text-text-secondary hover:text-white transition-colors"
            >
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="p-6 flex flex-col gap-6">
            <!-- Context Card -->
            <div
                class="flex gap-4 items-center p-4 rounded-xl bg-surface-dark border border-border-dark"
            >
                <div
                    class="size-16 rounded-lg bg-background-dark flex items-center justify-center text-text-secondary"
                >
                    <span class="material-symbols-outlined text-4xl"
                        >music_note</span
                    >
                </div>
                <div class="flex flex-col">
                    <h4 class="text-white font-bold text-lg leading-tight">
                        {selectedLog.song}
                    </h4>
                    <p class="text-text-secondary text-sm">
                        Played on {selectedLog.broadcaster}
                    </p>
                    <div class="flex items-center gap-1.5 mt-1">
                        <span
                            class="size-2 rounded-full bg-primary animate-live"
                        ></span>
                        <span class="text-xs text-primary font-medium"
                            >Processed</span
                        >
                    </div>
                </div>
            </div>

            <!-- Calculation Visualization -->
            <div class="flex flex-col gap-4">
                <div class="flex justify-between items-center mb-1">
                    <span
                        class="text-xs font-bold text-text-secondary uppercase tracking-widest"
                        >Calculation Flow</span
                    >
                    <span
                        class="material-symbols-outlined text-text-secondary text-[16px] cursor-help"
                        >help</span
                    >
                </div>

                <!-- Base Rate -->
                <div class="relative pl-6 pb-6 border-l-2 border-border-dark">
                    <span
                        class="absolute -left-[9px] top-0 size-4 rounded-full bg-border-dark border-2 border-surface-darker"
                    ></span>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-bold text-white">
                                Base Rate Duration
                            </p>
                            <p class="text-xs text-text-secondary mt-1">
                                {calculation.seconds} seconds × ${calculation.ratePerSec}/sec
                            </p>
                        </div>
                        <span class="font-mono text-white font-medium text-sm"
                            >${calculation.baseRate.toFixed(2)}</span
                        >
                    </div>
                </div>

                <!-- Multiplier -->
                <div class="relative pl-6 pb-6 border-l-2 border-border-dark">
                    <span
                        class="absolute -left-[9px] top-0 size-4 rounded-full bg-border-dark border-2 border-surface-darker"
                    ></span>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-bold text-white">
                                Market Multiplier
                            </p>
                            <p class="text-xs text-text-secondary mt-1">
                                {calculation.multiplierReason} (x {calculation.multiplier})
                            </p>
                        </div>
                        <span class="font-mono text-primary font-medium text-sm"
                            >x {calculation.multiplier}</span
                        >
                    </div>
                    <div
                        class="mt-2 p-2 bg-background-dark rounded text-xs text-text-secondary font-mono flex justify-between"
                    >
                        <span>Subtotal:</span>
                        <span>${calculation.subtotal.toFixed(2)}</span>
                    </div>
                </div>

                <!-- Fees -->
                <div class="relative pl-6 pb-6 border-l-2 border-border-dark">
                    <span
                        class="absolute -left-[9px] top-0 size-4 rounded-full bg-border-dark border-2 border-surface-darker"
                    ></span>
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-bold text-white">
                                PRO Admin Fees
                            </p>
                            <p class="text-xs text-text-secondary mt-1">
                                Standard deduction ({calculation.feePercent}%)
                            </p>
                        </div>
                        <span class="font-mono text-red-400 font-medium text-sm"
                            >- ${calculation.fees.toFixed(2)}</span
                        >
                    </div>
                </div>

                <!-- Result -->
                <div class="relative pl-6">
                    <span
                        class="absolute -left-[9px] top-0 size-4 rounded-full bg-primary border-2 border-surface-darker shadow-primary-glow"
                    ></span>
                    <div
                        class="flex flex-col gap-2 p-4 rounded-xl bg-primary/10 border border-primary/20"
                    >
                        <span class="text-sm font-bold text-white"
                            >Final Estimated Royalty</span
                        >
                        <span
                            class="text-3xl font-black text-primary tracking-tight"
                            >${calculation.final.toFixed(2)}</span
                        >
                        <p class="text-[10px] text-primary/70 mt-1">
                            Amount credited to your balance upon confirmation.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Educational Tip -->
            <div
                class="mt-auto p-4 bg-surface-dark rounded-lg border border-border-dark flex gap-3"
            >
                <span
                    class="material-symbols-outlined text-primary text-[20px] shrink-0"
                    >lightbulb</span
                >
                <p class="text-xs text-text-secondary leading-relaxed">
                    <strong class="text-white block mb-1">Did you know?</strong>
                    Nighttime broadcasts (12AM-6AM) often have a reduced base rate
                    multiplier of 0.75x in some territories like Germany.
                </p>
            </div>
        </div>
    </aside>
</div>
