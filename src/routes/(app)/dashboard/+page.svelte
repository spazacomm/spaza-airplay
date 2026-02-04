<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // Derived stats
    const totalEarnings = $derived(data?.summary?.total_earnings ?? 14560.5);
    const totalPlays = $derived(data?.summary?.total_plays ?? 24500);
    const networkHealth = { active: 142, offline: 3 };

    // Mock Data for Widgets
    const liveTicker = [
        { song: "Sitya Loss", source: "Classic 105", time: "Now" },
        { song: "Melanin", source: "Club 1824", time: "2s ago" },
        { song: "Suzanna", source: "Radio Citizen", time: "5s ago" },
        { song: "Extravaganza", source: "NRG Radio", time: "12s ago" },
    ];

    const topAssets = [
        {
            title: "Sitya Loss",
            plays: "8.5k",
            revenue: "$4,250",
            trend: "+12%",
        },
        { title: "Melanin", plays: "6.2k", revenue: "$3,100", trend: "+5%" },
        { title: "Suzanna", plays: "5.4k", revenue: "$2,700", trend: "-2%" },
    ];

    const topSources = [
        { name: "Classic 105", value: 45, color: "bg-primary" },
        { name: "Radio Citizen", value: 30, color: "bg-emerald-500" },
        { name: "Club 1824", value: 25, color: "bg-blue-500" },
    ];
</script>

<svelte:head>
    <title>Dashboard | Spaza Airplay</title>
</svelte:head>

<div class="p-8 max-w-[1600px] mx-auto space-y-6">
    <!-- Header -->
    <div class="flex items-end justify-between">
        <div>
            <h1 class="text-3xl font-bold tracking-tight text-text-main">
                Dashboard
            </h1>
            <p class="text-text-secondary mt-1">
                Real-time overview of your catalogue performance.
            </p>
        </div>
        <div class="flex gap-2">
            <button class="btn-secondary text-sm py-2">
                <span class="material-symbols-outlined text-[18px]"
                    >calendar_today</span
                >
                Last 30 Days
            </button>
            <button class="btn-primary text-sm py-2">
                <span class="material-symbols-outlined text-[18px]"
                    >download</span
                >
                Export Report
            </button>
        </div>
    </div>

    <!-- Real-Time Ticker -->
    <div
        class="bg-surface-dark border border-border-dark rounded-lg flex items-center overflow-hidden h-12 relative"
    >
        <div
            class="bg-primary/10 px-4 h-full flex items-center gap-2 border-r border-border-dark shrink-0 z-10"
        >
            <span class="relative flex h-2 w-2">
                <span
                    class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75"
                ></span>
                <span
                    class="relative inline-flex rounded-full h-2 w-2 bg-primary"
                ></span>
            </span>
            <span
                class="text-xs font-bold text-primary uppercase tracking-wider"
                >Live Feed</span
            >
        </div>
        <div class="flex-1 flex items-center overflow-hidden">
            <div
                class="flex items-center gap-8 animate-scroll whitespace-nowrap px-4 w-full"
            >
                {#each liveTicker as tick}
                    <div class="flex items-center gap-2 text-sm">
                        <span class="text-text-main font-bold">{tick.song}</span
                        >
                        <span class="text-text-secondary">on {tick.source}</span
                        >
                        <span class="text-xs text-text-muted"
                            >({tick.time})</span
                        >
                    </div>
                    <span class="text-border-dark">•</span>
                {/each}
                {#each liveTicker as tick}
                    <div class="flex items-center gap-2 text-sm">
                        <span class="text-text-main font-bold">{tick.song}</span
                        >
                        <span class="text-text-secondary">on {tick.source}</span
                        >
                        <span class="text-xs text-text-muted"
                            >({tick.time})</span
                        >
                    </div>
                    <span class="text-border-dark">•</span>
                {/each}
            </div>
        </div>
    </div>

    <!-- Main Grid -->
    <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
        <!-- Revenue Snapshot -->
        <div class="md:col-span-8 card relative overflow-hidden group">
            <div class="flex justify-between items-start z-10 relative">
                <div>
                    <h3
                        class="text-sm font-bold text-text-secondary uppercase tracking-wider mb-2"
                    >
                        Total Estimates (MTD)
                    </h3>
                    <div class="flex items-baseline gap-2">
                        <span class="text-4xl font-extrabold text-text-main"
                            >${totalEarnings.toLocaleString()}</span
                        >
                        <span
                            class="text-sm font-bold text-emerald-500 bg-emerald-500/10 px-2 py-0.5 rounded"
                            >+12.5%</span
                        >
                    </div>
                    <p class="text-xs text-text-secondary mt-2">
                        vs. last month ($12,450.00)
                    </p>
                </div>
                <div class="text-right">
                    <h3
                        class="text-sm font-bold text-text-secondary uppercase tracking-wider mb-2"
                    >
                        Total Plays
                    </h3>
                    <div class="flex items-baseline gap-2 justify-end">
                        <span class="text-2xl font-bold text-text-main"
                            >{totalPlays.toLocaleString()}</span
                        >
                        <span class="text-xs font-bold text-emerald-500"
                            >+8.2%</span
                        >
                    </div>
                </div>
            </div>
            <!-- Decorative Chart Background -->
            <div
                class="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-primary/5 to-transparent flex items-end justify-between px-6 gap-2 opacity-50"
            >
                {#each Array(20) as _, i}
                    <div
                        class="w-full bg-primary/20 rounded-t-sm"
                        style="height: {Math.random() * 100}%"
                    ></div>
                {/each}
            </div>
        </div>

        <!-- Network Health -->
        <div class="md:col-span-4 card">
            <div class="flex justify-between items-start mb-4">
                <h3
                    class="text-sm font-bold text-text-secondary uppercase tracking-wider"
                >
                    Network Status
                </h3>
                <span class="flex h-2 w-2 rounded-full bg-emerald-500"></span>
            </div>
            <div
                class="flex-1 flex flex-col justify-center items-center text-center"
            >
                <div
                    class="relative size-32 mb-4 flex items-center justify-center"
                >
                    <svg class="size-full -rotate-90" viewBox="0 0 36 36">
                        <!-- Background Circle -->
                        <path
                            class="text-text-muted/10"
                            d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="3"
                        />
                        <!-- Progress Circle -->
                        <path
                            class="text-primary"
                            stroke-dasharray="98, 100"
                            d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="3"
                        />
                    </svg>
                    <div
                        class="absolute inset-0 flex flex-col items-center justify-center"
                    >
                        <span class="text-3xl font-bold text-text-main"
                            >{networkHealth.active}</span
                        >
                        <span
                            class="text-[10px] uppercase font-bold text-text-secondary"
                            >Monitors</span
                        >
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-4 w-full">
                    <div
                        class="bg-background-dark p-2 rounded border border-border-dark"
                    >
                        <span class="block text-xl font-bold text-white"
                            >{networkHealth.active}</span
                        >
                        <span
                            class="text-[10px] text-emerald-500 uppercase font-bold"
                            >Online</span
                        >
                    </div>
                    <div
                        class="bg-background-dark p-2 rounded border border-border-dark"
                    >
                        <span class="block text-xl font-bold text-white"
                            >{networkHealth.offline}</span
                        >
                        <span
                            class="text-[10px] text-red-500 uppercase font-bold"
                            >Offline</span
                        >
                    </div>
                </div>
            </div>
        </div>

        <!-- Geographic Hitmap (Placeholder) -->
        <div class="md:col-span-8 card min-h-[300px] flex flex-col">
            <h3
                class="text-sm font-bold text-text-secondary uppercase tracking-wider mb-4"
            >
                Regional Performance
            </h3>
            <div
                class="flex-1 bg-background-dark rounded border border-border-dark relative overflow-hidden flex items-center justify-center group cursor-crosshair"
            >
                <div
                    class="absolute inset-0 opacity-20 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:16px_16px]"
                ></div>
                <span
                    class="material-symbols-outlined text-6xl text-text-secondary/20 group-hover:scale-110 transition-transform duration-500"
                    >public</span
                >
                <div
                    class="absolute top-1/2 left-1/2 -translate-x-12 -translate-y-8 size-4 bg-primary rounded-full animate-ping opacity-75"
                ></div>
                <div
                    class="absolute top-1/2 left-1/2 -translate-x-12 -translate-y-8 size-2 bg-primary rounded-full shadow-[0_0_20px_rgba(var(--color-primary),0.8)]"
                ></div>
            </div>
        </div>

        <!-- Top Sources -->
        <div class="md:col-span-4 card flex flex-col">
            <h3
                class="text-sm font-bold text-text-secondary uppercase tracking-wider mb-4"
            >
                Top Broadcasters
            </h3>
            <div class="space-y-4 flex-1">
                {#each topSources as source}
                    <div>
                        <div class="flex justify-between text-sm mb-1">
                            <span class="font-medium text-text-main"
                                >{source.name}</span
                            >
                            <span class="text-text-secondary"
                                >{source.value}%</span
                            >
                        </div>
                        <div
                            class="h-2 bg-background-dark rounded-full overflow-hidden"
                        >
                            <div
                                class="h-full {source.color}"
                                style="width: {source.value}%"
                            ></div>
                        </div>
                    </div>
                {/each}
            </div>
            <button class="btn-ghost w-full justify-center mt-4 text-sm"
                >View All Sources</button
            >
        </div>

        <!-- Top Performing Assets -->
        <div class="md:col-span-12 card">
            <div class="flex justify-between items-center mb-4">
                <h3
                    class="text-sm font-bold text-text-secondary uppercase tracking-wider"
                >
                    Top Performing Assets
                </h3>
                <a
                    href="/catalogue/works"
                    class="text-xs font-bold text-primary hover:underline"
                    >View Catalogue</a
                >
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead
                        class="bg-background-dark text-xs uppercase text-text-secondary font-bold"
                    >
                        <tr>
                            <th class="px-4 py-3 rounded-l-lg">Song Title</th>
                            <th class="px-4 py-3 text-right">Plays</th>
                            <th class="px-4 py-3 text-right">Est. Revenue</th>
                            <th class="px-4 py-3 text-right rounded-r-lg"
                                >Trend</th
                            >
                        </tr>
                    </thead>
                    <tbody class="text-sm divide-y divide-border-dark">
                        {#each topAssets as asset}
                            <tr
                                class="hover:bg-background-dark/50 transition-colors"
                            >
                                <td class="px-4 py-3 font-medium text-text-main"
                                    >{asset.title}</td
                                >
                                <td
                                    class="px-4 py-3 text-right text-text-secondary"
                                    >{asset.plays}</td
                                >
                                <td class="px-4 py-3 text-right text-text-main"
                                    >{asset.revenue}</td
                                >
                                <td
                                    class="px-4 py-3 text-right font-bold"
                                    class:text-emerald-500={asset.trend.startsWith(
                                        "+",
                                    )}
                                    class:text-red-500={asset.trend.startsWith(
                                        "-",
                                    )}>{asset.trend}</td
                                >
                            </tr>
                        {/each}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<style>
    @keyframes scroll {
        0% {
            transform: translateX(0);
        }
        100% {
            transform: translateX(-50%);
        }
    }
    .animate-scroll {
        animation: scroll 20s linear infinite;
    }
</style>
