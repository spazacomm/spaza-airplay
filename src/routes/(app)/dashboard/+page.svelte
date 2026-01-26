<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // Derived stats from data
    const stats = $derived({
        totalEarnings: data?.summary?.total_earnings ?? 0,
        earningsChange: 12.5,
        totalPlays:
            ((data?.summary?.total_plays ?? 0) / 1000000).toFixed(1) + "M",
        playsChange: 5,
        audienceGrowth: 15,
        activeTerritories: 8,
    });

    const recentPlays = $derived(data?.recentPlays ?? []);
    const topTracks = $derived(data?.topTracks ?? []);
</script>

<svelte:head>
    <title>Dashboard | Spaza Airplay</title>
</svelte:head>

<div class="max-w-7xl mx-auto flex flex-col gap-6">
    <!-- Page Heading -->
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h2 class="text-3xl font-bold tracking-tight">Dashboard</h2>
            <p class="text-text-secondary mt-1">
                Live overview of your music performance across all platforms.
            </p>
        </div>
        <div class="flex gap-2">
            <select class="select max-w-[150px] text-sm py-2">
                <option>Last 7 Days</option>
                <option>Last 30 Days</option>
                <option>This Year</option>
            </select>
            <button
                class="btn-secondary py-2 px-3"
                aria-label="Download report"
            >
                <span class="material-symbols-outlined text-[20px]"
                    >download</span
                >
            </button>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
        <!-- Large Earnings Card -->
        <div class="md:col-span-8 card relative overflow-hidden group">
            <div class="flex justify-between items-start z-10 relative">
                <div>
                    <p class="text-sm font-medium text-text-secondary mb-1">
                        Total Estimated Earnings
                    </p>
                    <h3 class="text-4xl font-extrabold tracking-tight">
                        ${stats.totalEarnings.toLocaleString("en-US", {
                            minimumFractionDigits: 2,
                        })}
                    </h3>
                </div>
                <div
                    class="flex items-center gap-1 text-emerald-500 bg-emerald-500/10 px-2 py-1 rounded text-sm font-bold"
                >
                    <span class="material-symbols-outlined text-[16px]"
                        >trending_up</span
                    >
                    <span>{stats.earningsChange}%</span>
                </div>
            </div>

            <!-- Decorative gradient -->
            <div
                class="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-primary/10 to-transparent pointer-events-none"
            ></div>
        </div>

        <!-- Stats Column -->
        <div class="md:col-span-4 flex flex-col gap-6">
            <!-- Total Plays -->
            <div class="stat-card flex-1">
                <div class="flex items-center gap-3 mb-2">
                    <div class="p-2 bg-blue-500/10 rounded-lg text-blue-500">
                        <span class="material-symbols-outlined"
                            >play_circle</span
                        >
                    </div>
                    <p class="text-sm font-medium text-text-secondary">
                        Total Plays
                    </p>
                </div>
                <div class="flex items-end gap-3">
                    <h3 class="text-3xl font-bold">{stats.totalPlays}</h3>
                    <span class="text-sm text-text-secondary mb-1">plays</span>
                </div>
                <p class="text-xs text-emerald-500 mt-2 font-medium">
                    +{stats.playsChange}% since last week
                </p>
            </div>

            <!-- Audience Growth -->
            <div class="stat-card flex-1 flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-text-secondary">
                        Audience Growth
                    </p>
                    <h3 class="text-2xl font-bold mt-1">
                        +{stats.audienceGrowth}%
                    </h3>
                </div>
                <div
                    class="h-12 w-12 rounded-full border-4 border-border-dark border-t-primary flex items-center justify-center"
                >
                    <span class="material-symbols-outlined text-primary text-sm"
                        >person_add</span
                    >
                </div>
            </div>
        </div>
    </div>

    <!-- Middle Section: Map + Recent Plays -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Map Placeholder -->
        <div class="lg:col-span-2 card flex flex-col min-h-[400px]">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-bold flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary"
                        >public</span
                    >
                    Airplay Distribution
                </h3>
                <a
                    href="/analytics/geographic"
                    class="btn-ghost text-sm text-primary">View Full Report</a
                >
            </div>

            <!-- Map Container -->
            <div
                class="flex-1 rounded-lg bg-background-dark relative overflow-hidden flex items-center justify-center"
            >
                <div class="text-center text-text-secondary">
                    <span
                        class="material-symbols-outlined text-6xl mb-4 opacity-30"
                        >map</span
                    >
                    <p class="text-sm">Interactive map loading...</p>
                </div>
            </div>
        </div>

        <!-- Recent Airplay Feed -->
        <div class="card flex flex-col h-[400px] p-0">
            <div class="p-6 border-b border-border-dark">
                <h3 class="text-lg font-bold flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary"
                        >radio</span
                    >
                    Recent Airplay
                </h3>
            </div>
            <div class="flex-1 overflow-y-auto p-4 space-y-2">
                {#each recentPlays as play}
                    <div
                        class="flex items-start gap-3 p-3 hover:bg-white/5 rounded-lg transition-colors cursor-pointer"
                    >
                        <div
                            class="size-10 rounded overflow-hidden bg-surface-dark flex items-center justify-center text-text-secondary"
                        >
                            {#if play.cover}
                                <img
                                    src={play.cover}
                                    alt={play.song}
                                    class="w-full h-full object-cover"
                                />
                            {:else}
                                <span class="material-symbols-outlined"
                                    >radio</span
                                >
                            {/if}
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="text-sm font-bold truncate">
                                {play.song}
                            </p>
                            <p class="text-xs text-text-secondary">
                                {play.station} • {play.location}
                            </p>
                        </div>
                        <span
                            class="text-xs font-medium whitespace-nowrap"
                            class:text-primary={play.isNew}
                            class:text-text-secondary={!play.isNew}
                        >
                            {play.time}
                        </span>
                    </div>
                {/each}
            </div>
        </div>
    </div>

    <!-- Top Performing Tracks -->
    <div class="card">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold">Top Performing Tracks</h3>
            <a href="/music/songs" class="btn-ghost text-sm text-primary"
                >View All</a
            >
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr
                        class="text-xs text-text-secondary uppercase border-b border-border-dark"
                    >
                        <th class="font-semibold py-3 pl-2">#</th>
                        <th class="font-semibold py-3">Track</th>
                        <th class="font-semibold py-3">Album</th>
                        <th class="font-semibold py-3 text-right"
                            >Total Plays</th
                        >
                        <th class="font-semibold py-3 text-right">Earnings</th>
                        <th class="font-semibold py-3 text-right pr-2">Trend</th
                        >
                    </tr>
                </thead>
                <tbody class="text-sm">
                    {#each topTracks as track}
                        <tr
                            class="table-row group border-b border-border-dark last:border-0"
                        >
                            <td class="py-3 pl-2 text-text-secondary"
                                >{track.rank}</td
                            >
                            <td class="py-3">
                                <div class="flex items-center gap-3">
                                    <div
                                        class="size-10 rounded bg-surface-dark flex items-center justify-center text-text-secondary"
                                    >
                                        <span class="material-symbols-outlined"
                                            >album</span
                                        >
                                    </div>
                                    <span
                                        class="font-bold group-hover:text-primary transition-colors"
                                        >{track.title}</span
                                    >
                                </div>
                            </td>
                            <td class="py-3 text-text-secondary"
                                >{track.album}</td
                            >
                            <td class="py-3 text-right font-medium"
                                >{track.plays}</td
                            >
                            <td class="py-3 text-right font-medium"
                                >${track.earnings.toLocaleString()}</td
                            >
                            <td class="py-3 text-right pr-2">
                                <span
                                    class="text-xs font-bold"
                                    class:text-emerald-500={track.trend > 0}
                                    class:text-red-500={track.trend < 0}
                                >
                                    {track.trend > 0 ? "+" : ""}{track.trend}%
                                </span>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>
    </div>
</div>
