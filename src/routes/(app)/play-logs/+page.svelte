<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // Mock Logs Data with Confidence and Audio
    const logs = [
        {
            id: "log-001",
            timestamp: "Today, 10:42 AM",
            song: "Sitya Loss",
            artist: "Eddy Kenzo",
            broadcaster: "Classic 105",
            country: "KE",
            duration: "3:45",
            confidence: 0.98,
            status: "verified",
            audio_url: "https://example.com/audio1.mp3",
        },
        {
            id: "log-002",
            timestamp: "Today, 10:38 AM",
            song: "Melanin",
            artist: "Sauti Sol",
            broadcaster: "Radio Citizen",
            country: "KE",
            duration: "4:12",
            confidence: 0.85,
            status: "pending",
            audio_url: "https://example.com/audio2.mp3",
        },
        {
            id: "log-003",
            timestamp: "Today, 10:15 AM",
            song: "Extravaganza",
            artist: "Sauti Sol",
            broadcaster: "NRG Radio",
            country: "KE",
            duration: "3:30",
            confidence: 0.65, // Low confidence
            status: "flagged",
            audio_url: "https://example.com/audio3.mp3",
        },
    ];

    let selectedLogId = $state(logs[0].id);
    let isPlaying = $state(false);

    const selectedLog = $derived(
        logs.find((l) => l.id === selectedLogId) || logs[0],
    );

    function togglePlayback() {
        // Toggle mock playback state
        isPlaying = !isPlaying;
    }

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
    <div
        class="flex-1 flex flex-col min-w-0 bg-background-dark relative border-r border-border-dark"
    >
        <!-- Header -->
        <div class="px-8 py-6 border-b border-border-dark shrink-0">
            <div class="flex justify-between items-end">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight text-white">
                        Detection History
                    </h1>
                    <p class="text-text-secondary text-sm">
                        Verify and audit your airplay logs.
                    </p>
                </div>
                <div class="flex gap-2">
                    <button class="btn-secondary text-sm">
                        <span class="material-symbols-outlined text-[18px]"
                            >filter_list</span
                        >
                        Advanced Filters
                    </button>
                    <button class="btn-primary text-sm">
                        <span class="material-symbols-outlined text-[18px]"
                            >download</span
                        >
                        Export CSV
                    </button>
                </div>
            </div>
        </div>

        <!-- Filters Toolbar -->
        <div
            class="px-8 py-4 shrink-0 grid grid-cols-4 gap-4 border-b border-border-dark bg-surface-darker/50"
        >
            <label class="flex flex-col gap-1.5">
                <span class="text-xs font-bold text-text-muted uppercase"
                    >Date Range</span
                >
                <select
                    class="select py-2 text-sm bg-background-dark border-border-dark"
                >
                    <option>Last 24 Hours</option>
                    <option>Last 7 Days</option>
                    <option>Custom Range</option>
                </select>
            </label>
            <label class="flex flex-col gap-1.5">
                <span class="text-xs font-bold text-text-muted uppercase"
                    >Source</span
                >
                <select
                    class="select py-2 text-sm bg-background-dark border-border-dark"
                >
                    <option>All Sources</option>
                    <option>Classic 105</option>
                    <option>Radio Citizen</option>
                </select>
            </label>
            <label class="flex flex-col gap-1.5">
                <span class="text-xs font-bold text-text-muted uppercase"
                    >Min. Confidence</span
                >
                <select
                    class="select py-2 text-sm bg-background-dark border-border-dark"
                >
                    <option value="0.9">90% + (High)</option>
                    <option value="0.7">70% + (Medium)</option>
                    <option value="0">All Matches</option>
                </select>
            </label>
            <label class="flex flex-col gap-1.5">
                <span class="text-xs font-bold text-text-muted uppercase"
                    >Search</span
                >
                <input
                    type="text"
                    class="input py-2 text-sm bg-background-dark border-border-dark"
                    placeholder="Song or Artist..."
                />
            </label>
        </div>

        <!-- Table -->
        <div class="flex-1 overflow-auto">
            <table class="w-full text-left border-collapse">
                <thead class="bg-surface-dark sticky top-0 z-10 shadow-sm">
                    <tr>
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Time</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Song & Artist</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Source</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Confidence</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary text-right"
                            >Duration</th
                        >
                    </tr>
                </thead>
                <tbody class="divide-y divide-border-dark bg-background-dark">
                    {#each logs as log}
                        <tr
                            class="group hover:bg-surface-dark cursor-pointer transition-colors border-l-4"
                            class:border-l-transparent={selectedLogId !==
                                log.id}
                            class:border-l-primary={selectedLogId === log.id}
                            class:bg-surface-dark={selectedLogId === log.id}
                            onclick={() => (selectedLogId = log.id)}
                        >
                            <td
                                class="py-4 px-6 text-sm text-text-secondary whitespace-nowrap"
                                >{log.timestamp}</td
                            >
                            <td class="py-4 px-6">
                                <div class="flex flex-col">
                                    <span class="font-bold text-white text-sm"
                                        >{log.song}</span
                                    >
                                    <span class="text-xs text-text-muted"
                                        >{log.artist}</span
                                    >
                                </div>
                            </td>
                            <td class="py-4 px-6">
                                <div class="flex items-center gap-2">
                                    <span
                                        class="material-symbols-outlined text-text-muted text-sm"
                                        >radio</span
                                    >
                                    <span class="text-sm text-text-main"
                                        >{log.broadcaster}</span
                                    >
                                </div>
                            </td>
                            <td class="py-4 px-6">
                                <div class="flex items-center gap-2">
                                    <div
                                        class="w-16 h-1.5 bg-background-surface-alt rounded-full overflow-hidden"
                                    >
                                        <div
                                            class="h-full rounded-full {log.confidence >
                                            0.9
                                                ? 'bg-emerald-500'
                                                : log.confidence > 0.7
                                                  ? 'bg-yellow-500'
                                                  : 'bg-red-500'}"
                                            style="width: {log.confidence *
                                                100}%"
                                        ></div>
                                    </div>
                                    <span
                                        class="text-xs font-mono text-text-secondary"
                                        >{(log.confidence * 100).toFixed(
                                            0,
                                        )}%</span
                                    >
                                </div>
                            </td>
                            <td
                                class="py-4 px-6 text-sm text-text-secondary text-right font-mono"
                                >{log.duration}</td
                            >
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>
    </div>

    <!-- Inspector: Audio Verification -->
    <aside
        class="w-[380px] bg-surface-darker border-l border-border-dark flex flex-col shrink-0 shadow-2xl z-20"
    >
        {#if selectedLog}
            <div class="p-6 border-b border-border-dark">
                <div class="flex justify-between items-start mb-4">
                    <span
                        class="badge {selectedLog.confidence > 0.8
                            ? 'badge-success'
                            : 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20'} uppercase text-xs"
                    >
                        {selectedLog.confidence > 0.8
                            ? "High Confidence"
                            : "Review Needed"}
                    </span>
                    <button
                        class="text-text-muted hover:text-white"
                        title="Flag as False Positive"
                    >
                        <span class="material-symbols-outlined">flag</span>
                    </button>
                </div>
                <h2 class="text-xl font-bold text-white mb-1">
                    {selectedLog.song}
                </h2>
                <p class="text-primary font-medium">{selectedLog.artist}</p>
                <div
                    class="mt-4 flex items-center gap-4 text-sm text-text-secondary"
                >
                    <div class="flex items-center gap-1">
                        <span class="material-symbols-outlined text-sm"
                            >schedule</span
                        >
                        {selectedLog.timestamp}
                    </div>
                    <div class="flex items-center gap-1">
                        <span class="material-symbols-outlined text-sm"
                            >radio</span
                        >
                        {selectedLog.broadcaster}
                    </div>
                </div>
            </div>

            <div class="p-6 flex-1 overflow-y-auto space-y-6">
                <!-- Audio Player -->
                <div
                    class="bg-background-dark rounded-xl border border-border-dark p-4"
                >
                    <div class="flex justify-between items-center mb-4">
                        <span
                            class="text-xs font-bold text-text-muted uppercase tracking-wider"
                            >Audio Verification</span
                        >
                        {#if isPlaying}
                            <div class="flex gap-1 h-3 items-end">
                                <div
                                    class="w-1 bg-primary animate-music-bar-1"
                                ></div>
                                <div
                                    class="w-1 bg-primary animate-music-bar-2"
                                ></div>
                                <div
                                    class="w-1 bg-primary animate-music-bar-3"
                                ></div>
                            </div>
                        {/if}
                    </div>

                    <div class="flex gap-4 items-center">
                        <button
                            class="size-12 rounded-full bg-primary text-background-dark flex items-center justify-center hover:scale-105 transition-transform"
                            onclick={togglePlayback}
                        >
                            <span
                                class="material-symbols-outlined text-2xl ml-1"
                                >{isPlaying ? "pause" : "play_arrow"}</span
                            >
                        </button>
                        <div class="flex-1 space-y-1">
                            <div
                                class="h-1 bg-surface-dark rounded-full overflow-hidden"
                            >
                                <div class="h-full bg-primary w-1/3 relative">
                                    <div
                                        class="absolute right-0 top-1/2 -translate-y-1/2 size-2 rounded-full bg-white shadow"
                                    ></div>
                                </div>
                            </div>
                            <div
                                class="flex justify-between text-[10px] text-text-muted font-mono"
                            >
                                <span>0:15</span>
                                <span>0:45</span>
                            </div>
                        </div>
                    </div>
                    <div class="mt-4 grid grid-cols-2 gap-2 text-xs">
                        <div
                            class="p-2 rounded bg-surface-dark text-center border border-border-dark"
                        >
                            <span class="block text-text-muted mb-1"
                                >Snippet Source</span
                            >
                            <span class="font-bold text-white"
                                >Broadcast Rec.</span
                            >
                        </div>
                        <div
                            class="p-2 rounded bg-surface-dark text-center border border-border-dark"
                        >
                            <span class="block text-text-muted mb-1"
                                >Fingerprint ID</span
                            >
                            <span class="font-mono text-white">#9A2F3D</span>
                        </div>
                    </div>
                </div>

                <!-- Match Details -->
                <section>
                    <h3 class="text-sm font-bold text-white mb-3">
                        Match Analysis
                    </h3>
                    <div class="space-y-3">
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-text-secondary"
                                >Acoustic Fingerprint</span
                            >
                            <span
                                class="text-emerald-500 font-bold flex items-center gap-1"
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >check_circle</span
                                >
                                Match
                            </span>
                        </div>
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-text-secondary"
                                >Metadata Parse</span
                            >
                            <span
                                class="text-emerald-500 font-bold flex items-center gap-1"
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >check_circle</span
                                >
                                Verified
                            </span>
                        </div>
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-text-secondary"
                                >Duration Confidence</span
                            >
                            <span
                                class="text-yellow-500 font-bold flex items-center gap-1"
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >warning</span
                                >
                                Deviation (+3s)
                            </span>
                        </div>
                    </div>
                </section>

                <!-- Calculation Visualization -->
                <div
                    class="flex flex-col gap-4 pt-4 border-t border-border-dark/50"
                >
                    <div class="flex justify-between items-center mb-1">
                        <span
                            class="text-xs font-bold text-text-secondary uppercase tracking-widest"
                            >Calculation Flow</span
                        >
                    </div>

                    <!-- Base Rate -->
                    <div
                        class="relative pl-6 pb-2 border-l-2 border-border-dark"
                    >
                        <span
                            class="absolute -left-[9px] top-0 size-4 rounded-full bg-border-dark border-2 border-surface-darker"
                        ></span>
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-xs text-text-secondary">
                                    Base Rate ({calculation.seconds}s)
                                </p>
                            </div>
                            <span
                                class="font-mono text-white font-medium text-xs"
                                >${calculation.baseRate.toFixed(2)}</span
                            >
                        </div>
                    </div>

                    <!-- Result -->
                    <div class="relative pl-6">
                        <span
                            class="absolute -left-[9px] top-0 size-4 rounded-full bg-emerald-500 border-2 border-surface-darker"
                        ></span>
                        <div class="flex justify-between items-center">
                            <span class="text-xs font-bold text-white"
                                >Estimated Royalty</span
                            >
                            <span class="text-lg font-bold text-emerald-500"
                                >${calculation.final.toFixed(2)}</span
                            >
                        </div>
                    </div>
                </div>
            </div>

            <div class="p-4 border-t border-border-dark text-center">
                <button
                    class="btn-ghost w-full text-red-400 hover:text-red-300"
                >
                    Flag as Incorrect Match
                </button>
            </div>
        {/if}
    </aside>
</div>

<style>
    @keyframes music-bar {
        0%,
        100% {
            height: 20%;
        }
        50% {
            height: 100%;
        }
    }
    .animate-music-bar-1 {
        animation: music-bar 0.8s infinite ease-in-out;
    }
    .animate-music-bar-2 {
        animation: music-bar 1.1s infinite ease-in-out;
        animation-delay: 0.1s;
    }
    .animate-music-bar-3 {
        animation: music-bar 0.9s infinite ease-in-out;
        animation-delay: 0.2s;
    }
</style>
