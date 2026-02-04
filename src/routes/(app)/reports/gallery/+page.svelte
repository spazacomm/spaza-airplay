<script lang="ts">
    import { fly, fade } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    // Mock Reports
    const categories = [
        {
            id: "comp",
            name: "Compliance",
            icon: "gavel",
            reports: [
                {
                    id: "c1",
                    title: "Broadcast Compliance Audit",
                    description:
                        "Detailed log of ad vs song transmission ratios.",
                    type: "PDF/CSV",
                },
                {
                    id: "c2",
                    title: "CMO Reporting Pack",
                    description:
                        "Standardized monthly submission for MCSK/KAMP.",
                    type: "ZIP",
                },
            ],
        },
        {
            id: "fin",
            name: "Financial",
            icon: "account_balance_wallet",
            reports: [
                {
                    id: "f1",
                    title: "Revenue Forecast",
                    description:
                        "Projected royalty income based on current airplay trends.",
                    type: "XLSX",
                },
                {
                    id: "f2",
                    title: "Historical Payouts Summary",
                    description:
                        "Aggregated view of all previous distributions.",
                    type: "PDF",
                },
            ],
        },
        {
            id: "anl",
            name: "Analytics",
            icon: "monitoring",
            reports: [
                {
                    id: "a1",
                    title: "Market Share Analysis",
                    description: "Top artists and labels by broadcast volume.",
                    type: "Interactive",
                },
                {
                    id: "a2",
                    title: "Regional Airplay Heatmap",
                    description:
                        "Visual distribution of detections across Kenya/Uganda.",
                    type: "Visual",
                },
            ],
        },
    ];

    // Selection State
    let selectedReport = $state<any>(null);
    let isParamsOpen = $state(false);

    function openParams(report: any) {
        selectedReport = report;
        isParamsOpen = true;
    }

    function handleRun() {
        // Mock triggering
        isParamsOpen = false;
    }
</script>

<svelte:head>
    <title>Reports Gallery | Spaza Airplay</title>
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
                <ctrl42>:hover:text-glow>Dashboard</a
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                >Reports & Alerts</span
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Reports Gallery</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-surface-darker border border-border-dark flex items-center justify-center text-primary shadow-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >summarize</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-white tracking-tight leading-none"
                    >
                        Reports Gallery
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Generate specialized compliance and analytical reports
                    </p>
                </div>
            </div>
        </div>
    </header>

    <!-- Content -->
    <main class="flex-1 overflow-y-auto p-8">
        <div class="max-w-7xl mx-auto space-y-12">
            {#each categories as category}
                <section class="space-y-6">
                    <div class="flex items-center gap-3">
                        <div
                            class="size-8 rounded-lg bg-surface-darker border border-border-dark flex items-center justify-center text-text-muted"
                        >
                            <span class="material-symbols-outlined text-xl"
                                >{category.icon}</span
                            >
                        </div>
                        <h2
                            class="text-xs font-black text-white uppercase tracking-[0.2em]"
                        >
                            {category.name} Reports
                        </h2>
                        <div class="h-px flex-1 bg-border-dark/50"></div>
                    </div>

                    <div
                        class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
                    >
                        {#each category.reports as report}
                            <div
                                class="group bg-surface-darker/30 border border-border-dark/50 rounded-2xl p-6 hover:bg-surface-darker transition-all duration-300 hover:border-primary/30 cursor-pointer shadow-sm relative overflow-hidden flex flex-col justify-between h-48"
                                onclick={() => openParams(report)}
                            >
                                <div
                                    class="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity"
                                ></div>

                                <div class="relative z-10">
                                    <div
                                        class="flex justify-between items-start mb-4"
                                    >
                                        <div
                                            class="size-10 rounded-xl bg-surface-dark border border-border-dark flex items-center justify-center text-text-muted group-hover:text-primary transition-colors"
                                        >
                                            <span
                                                class="material-symbols-outlined"
                                                >description</span
                                            >
                                        </div>
                                        <span
                                            class="px-2 py-0.5 rounded border border-border-dark bg-background-dark text-[9px] font-bold text-text-muted"
                                            >{report.type}</span
                                        >
                                    </div>
                                    <h3
                                        class="text-sm font-bold text-white tracking-tight group-hover:text-primary transition-colors"
                                    >
                                        {report.title}
                                    </h3>
                                    <p
                                        class="text-[11px] text-text-muted mt-2 leading-relaxed line-clamp-2"
                                    >
                                        {report.description}
                                    </p>
                                </div>

                                <div
                                    class="relative z-10 pt-4 border-t border-border-dark/30 flex justify-between items-center opacity-0 group-hover:opacity-100 transition-all transform translate-y-2 group-hover:translate-y-0"
                                >
                                    <span
                                        class="text-[10px] font-bold text-primary uppercase tracking-widest"
                                        >Configure & Run</span
                                    >
                                    <span
                                        class="material-symbols-outlined text-primary text-lg"
                                        >arrow_forward</span
                                    >
                                </div>
                            </div>
                        {/each}
                    </div>
                </section>
            {/each}
        </div>
    </main>

    <!-- Report Params Offcanvas -->
    {#if isParamsOpen && selectedReport}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isParamsOpen = false)}
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
            <div class="p-8 border-b border-border-dark bg-surface-darker/50">
                <div class="flex justify-between items-start mb-6">
                    <div
                        class="size-12 rounded-2xl bg-surface-dark border border-border-dark flex items-center justify-center text-primary shadow-xl"
                    >
                        <span class="material-symbols-outlined text-2xl"
                            >monitoring</span
                        >
                    </div>
                    <button
                        class="size-9 rounded-xl bg-surface-darker border border-border-dark text-text-muted hover:text-white flex items-center justify-center transition-all"
                        onclick={() => (isParamsOpen = false)}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
                <h2
                    class="text-2xl font-black text-white tracking-tighter uppercase"
                >
                    {selectedReport.title}
                </h2>
                <p
                    class="text-[10px] text-text-muted font-bold uppercase tracking-[0.2em] mt-2"
                >
                    Execution Parameters
                </p>
            </div>

            <div class="flex-1 overflow-y-auto p-8 space-y-8">
                <div class="space-y-6">
                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Report Timeframe</label
                        >
                        <select class="select w-full">
                            <option>Last 30 Days</option>
                            <option>Current Quarter</option>
                            <option>Custom Range</option>
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Target Entity</label
                        >
                        <select class="select w-full">
                            <option>All Sources (Kenya)</option>
                            <option>Commercial Radio Only</option>
                            <option>Specific CMO: MCSK</option>
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Output Format</label
                        >
                        <div class="grid grid-cols-3 gap-2 mt-2">
                            <button
                                class="p-4 rounded-xl border border-border-dark bg-surface-darker flex flex-col items-center gap-2 hover:border-primary/40 transition-all font-bold text-[10px] text-text-secondary hover:text-white"
                            >
                                <span class="material-symbols-outlined text-lg"
                                    >picture_as_pdf</span
                                >
                                PDF
                            </button>
                            <button
                                class="p-4 rounded-xl border border-primary/30 bg-primary/5 flex flex-col items-center gap-2 transition-all font-bold text-[10px] text-primary"
                            >
                                <span class="material-symbols-outlined text-lg"
                                    >csv</span
                                >
                                CSV
                            </button>
                            <button
                                class="p-4 rounded-xl border border-border-dark bg-surface-darker flex flex-col items-center gap-2 hover:border-primary/40 transition-all font-bold text-[10px] text-text-secondary hover:text-white"
                            >
                                <span class="material-symbols-outlined text-lg"
                                    >sim_card_download</span
                                >
                                XLSX
                            </button>
                        </div>
                    </div>
                </div>

                <div
                    class="p-6 rounded-2xl bg-surface-darker border border-border-dark space-y-3"
                >
                    <div class="flex items-center gap-3">
                        <span class="material-symbols-outlined text-amber-500"
                            >warning</span
                        >
                        <h4
                            class="text-xs font-bold text-white uppercase tracking-widest"
                        >
                            Storage Notice
                        </h4>
                    </div>
                    <p class="text-[11px] text-text-muted leading-relaxed">
                        Large reports (Audit logs over 1 year) may take up to <strong
                            >2 minutes</strong
                        >
                        to generate. An email notification will be sent once the
                        file is ready in the <strong>Downloads</strong> hub.
                    </p>
                </div>
            </div>

            <div class="p-6 border-t border-border-dark bg-surface-darker/50">
                <button
                    class="w-full btn-primary py-4 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 transition-all flex items-center justify-center gap-2"
                    onclick={handleRun}
                >
                    <span class="material-symbols-outlined">auto_awesome</span>
                    Run Specialized Report
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
    .select {
        height: 3rem;
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(51, 65, 85, 0.5);
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 2.5rem;
        color: white;
        font-size: 0.875rem;
        font-weight: 500;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(148, 163, 184, 1)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 0.75rem center;
        background-size: 1.25rem;
        cursor: pointer;
    }
</style>
