<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // Derived stats
    const summary = $derived(data?.summary);
    const totalEarnings = $derived(summary?.total_earnings ?? 0);
    const totalPlays = $derived(summary?.total_plays ?? 0);
    const activeSources = $derived(summary?.active_sources ?? 0);

    // Live Ticker from recent plays
    const liveTicker = $derived(
        (data?.recentPlays || []).map((p) => ({
            song: p.song,
            source: p.station,
            time: p.time,
        })),
    );

    // Top Assets from top tracks
    const topAssets = $derived(
        (data?.topTracks || []).map((t) => ({
            title: t.title,
            plays: t.plays.toLocaleString(),
            revenue: `$${t.earnings.toLocaleString()}`,
            trend: `+${t.trend}%`,
        })),
    );

    const networkHealth = $derived({ active: activeSources, offline: 0 });

    const topSources = [
        { name: "Citizen FM", value: 45, color: "bg-primary" },
        { name: "Classic 105", value: 30, color: "bg-emerald-500" },
        { name: "Clouds FM", value: 25, color: "bg-blue-500" },
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
        class="bg-white border border-border-dark rounded-md flex items-center overflow-hidden h-10 relative shadow-saas-sm"
    >
        <div
            class="bg-primary/5 px-4 h-full flex items-center gap-2 border-r border-border-dark shrink-0 z-10"
        >
            <span class="material-symbols-outlined text-primary text-lg"
                >sensors</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Live Broadcast</span
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
            <div class="flex flex-col items-center justify-center gap-6 p-6">
                <div class="relative flex items-center justify-center">
                    <div
                        class="absolute inset-0 bg-primary/20 rounded-full blur-2xl opacity-20"
                    ></div>
                    <div
                        class="size-24 rounded-full border border-border-dark flex items-center justify-center bg-white shadow-saas-sm"
                    >
                        <span
                            class="material-symbols-outlined text-4xl text-primary"
                            >language</span
                        >
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-4 w-full">
                    <div
                        class="bg-background-darker p-3 rounded-md border border-border-dark hover:border-primary/30 transition-colors"
                    >
                        <span class="block text-xl font-bold text-text-primary"
                            >{networkHealth.active}</span
                        >
                        <span
                            class="text-[10px] text-primary uppercase font-bold tracking-wider"
                            >Online</span
                        >
                    </div>
                    <div
                        class="bg-background-darker p-3 rounded-md border border-border-dark hover:border-red-500/30 transition-colors"
                    >
                        <span class="block text-xl font-bold text-text-primary"
                            >{networkHealth.offline}</span
                        >
                        <span
                            class="text-[10px] text-red-600 uppercase font-bold tracking-wider"
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
                class="flex-1 bg-background-darker rounded-lg border border-border-dark relative overflow-hidden flex items-center justify-center group cursor-crosshair shadow-inner"
            >
                <div
                    class="absolute inset-0 opacity-10 bg-[radial-gradient(var(--color-text-muted)_1px,transparent_1px)] [background-size:16px_16px]"
                ></div>
                <span
                    class="material-symbols-outlined text-6xl text-text-muted/10 group-hover:scale-110 group-hover:text-primary/10 transition-all duration-700"
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
                        class="bg-background-darker text-[10px] uppercase text-text-secondary font-bold tracking-widest border-b border-border-dark"
                    >
                        <tr>
                            <th class="px-4 py-3 rounded-l-md">Song Title</th>
                            <th class="px-4 py-3 text-right">Plays</th>
                            <th class="px-4 py-3 text-right">Est. Revenue</th>
                            <th class="px-4 py-3 text-right rounded-r-md"
                                >Trend</th
                            >
                        </tr>
                    </thead>
                    <tbody class="text-sm divide-y divide-border-dark/50">
                        {#each topAssets as asset}
                            <tr
                                class="hover:bg-background-dark/80 transition-colors group"
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
