<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    // Fallback to empty array if data fails
    const songs = $derived(data?.songs ?? []);

    let selectedSongId = $state("");

    $effect(() => {
        if (!selectedSongId && songs.length > 0) {
            selectedSongId = songs[0].id;
        }
    });

    const selectedSong = $derived(
        songs.find((s: any) => s.id === selectedSongId) || songs[0] || {},
    );

    // Filter states
    let genres = $state(["Pop", "Electronic", "Hip Hop", "Indie Rock"]);
    let territory = $state("Worldwide");
    let statuses = $state({ live: true, pending: false, takedown: false });
</script>

<svelte:head>
    <title>My Tracks | Spaza Airplay</title>
</svelte:head>

<div class="flex h-full overflow-hidden -m-4 md:-m-8">
    <!-- Left: Filters (Visible on large screens) -->
    <aside
        class="w-64 border-r border-border-dark bg-surface-darker flex flex-col overflow-y-auto hidden lg:flex shrink-0"
    >
        <div class="p-6">
            <div class="flex items-center justify-between mb-6">
                <h3
                    class="text-sm font-bold uppercase tracking-wider text-text-secondary"
                >
                    Filters
                </h3>
                <button class="text-xs text-primary font-medium hover:underline"
                    >Reset</button
                >
            </div>

            <!-- Genre -->
            <div class="mb-8">
                <h4 class="text-sm font-semibold mb-3">Genre</h4>
                <div class="space-y-3">
                    {#each genres as genre}
                        <label
                            class="flex items-center gap-3 cursor-pointer group"
                        >
                            <input
                                type="checkbox"
                                class="rounded border-text-muted bg-transparent text-primary focus:ring-primary focus:ring-offset-0 size-4"
                            />
                            <span
                                class="text-sm text-text-secondary group-hover:text-primary transition-colors"
                                >{genre}</span
                            >
                        </label>
                    {/each}
                </div>
            </div>

            <!-- Territory -->
            <div class="mb-8">
                <h4 class="text-sm font-semibold mb-3">Territory</h4>
                <div class="relative">
                    <select class="select py-2 text-sm pr-10">
                        <option>Worldwide</option>
                        <option>North America</option>
                        <option>Europe</option>
                        <option>Asia Pacific</option>
                    </select>
                    <span
                        class="material-symbols-outlined absolute right-3 top-2 text-text-secondary pointer-events-none"
                    >
                        expand_more
                    </span>
                </div>
            </div>

            <!-- Status Swiches -->
            <div>
                <h4 class="text-sm font-semibold mb-3">Status</h4>
                <div class="space-y-4">
                    <div class="flex items-center justify-between">
                        <span class="text-sm text-text-secondary">Live</span>
                        <button
                            class="w-10 h-5 bg-primary rounded-full relative transition-colors"
                            onclick={() => (statuses.live = !statuses.live)}
                            aria-label="Toggle live status"
                        >
                            <span
                                class="absolute top-1 size-3 bg-background-dark rounded-full shadow-sm transition-all"
                                class:right-1={statuses.live}
                                class:left-1={!statuses.live}
                            ></span>
                        </button>
                    </div>
                    <div class="flex items-center justify-between">
                        <span class="text-sm text-text-secondary">Pending</span>
                        <button
                            class="w-10 h-5 rounded-full relative transition-colors"
                            class:bg-primary={statuses.pending}
                            class:bg-border-dark={!statuses.pending}
                            onclick={() =>
                                (statuses.pending = !statuses.pending)}
                            aria-label="Toggle pending status"
                        >
                            <span
                                class="absolute top-1 size-3 rounded-full shadow-sm transition-all"
                                class:bg-background-dark={statuses.pending}
                                class:bg-text-secondary={!statuses.pending}
                                class:right-1={statuses.pending}
                                class:left-1={!statuses.pending}
                            ></span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </aside>

    <!-- Middle: Songs Table -->
    <main class="flex-1 flex flex-col min-w-0 bg-surface-darker relative">
        <!-- Page Header -->
        <div class="px-8 py-6 border-b border-border-dark shrink-0">
            <div class="flex flex-col gap-6">
                <div class="flex flex-wrap gap-2 items-center text-sm">
                    <a
                        class="text-text-secondary hover:text-primary transition-colors font-medium"
                        href="/dashboard">Dashboard</a
                    >
                    <span
                        class="material-symbols-outlined text-text-secondary text-sm"
                        >chevron_right</span
                    >
                    <span class="text-white font-semibold">Catalog</span>
                </div>
                <div
                    class="flex flex-col md:flex-row md:items-end justify-between gap-4"
                >
                    <div>
                        <h1 class="text-3xl font-bold tracking-tight">
                            My Tracks
                        </h1>
                        <p class="text-text-secondary mt-1 text-sm">
                            Manage your releases, check stats, and assign
                            rights.
                        </p>
                    </div>
                    <div class="flex gap-4">
                        <div
                            class="px-4 py-3 rounded-lg border border-border-dark bg-surface-dark min-w-[140px]"
                        >
                            <p
                                class="text-text-secondary text-xs font-medium uppercase tracking-wide mb-1"
                            >
                                Total Earnings
                            </p>
                            <p class="text-2xl font-bold">$142,503</p>
                        </div>
                        <div
                            class="px-4 py-3 rounded-lg border border-border-dark bg-surface-dark min-w-[140px]"
                        >
                            <p
                                class="text-text-secondary text-xs font-medium uppercase tracking-wide mb-1"
                            >
                                Active Tracks
                            </p>
                            <p class="text-2xl font-bold text-primary">48</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="flex-1 overflow-auto">
            <table class="w-full text-left border-collapse">
                <thead class="bg-surface-dark sticky top-0 z-10 shadow-sm">
                    <tr>
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Track Name</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >ISRC</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Date</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary"
                            >Status</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary text-right"
                            >Total Plays</th
                        >
                        <th
                            class="py-3 px-6 text-xs font-semibold uppercase tracking-wider text-text-secondary text-right"
                            >Earnings</th
                        >
                        <th class="py-3 px-6 w-10"></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-border-dark">
                    {#each songs as song}
                        <tr
                            class="table-row group relative"
                            class:table-row-active={selectedSongId === song.id}
                            onclick={() => (selectedSongId = song.id)}
                        >
                            {#if selectedSongId === song.id}
                                <td
                                    class="absolute left-0 top-0 bottom-0 w-1 bg-primary"
                                ></td>
                            {/if}
                            <td class="py-4 px-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="size-10 rounded overflow-hidden bg-surface-dark flex items-center justify-center text-text-secondary shrink-0"
                                    >
                                        {#if song.cover}
                                            <img
                                                src={song.cover}
                                                alt={song.title}
                                                class="w-full h-full object-cover"
                                            />
                                        {:else}
                                            <span
                                                class="material-symbols-outlined"
                                                >album</span
                                            >
                                        {/if}
                                    </div>
                                    <div>
                                        <p class="font-bold text-sm">
                                            {song.title}
                                        </p>
                                        <p class="text-xs text-text-secondary">
                                            {song.artist} - {song.genre}
                                        </p>
                                    </div>
                                </div>
                            </td>
                            <td
                                class="py-4 px-6 text-sm text-text-secondary font-mono"
                                >{song.isrc}</td
                            >
                            <td class="py-4 px-6 text-sm">{song.date}</td>
                            <td class="py-4 px-6">
                                <span
                                    class="badge"
                                    class:badge-success={song.status === "Live"}
                                    class:badge-warning={song.status ===
                                        "Pending"}
                                    class:badge-error={song.status ===
                                        "Takedown"}
                                >
                                    {song.status}
                                </span>
                            </td>
                            <td
                                class="py-4 px-6 text-right text-sm font-medium tabular-nums"
                                >{song.plays}</td
                            >
                            <td
                                class="py-4 px-6 text-right text-sm font-medium tabular-nums"
                                >{song.earnings}</td
                            >
                            <td class="py-4 px-6 text-center">
                                <button
                                    class="text-text-muted hover:text-white opacity-0 group-hover:opacity-100 transition-opacity"
                                >
                                    <span class="material-symbols-outlined"
                                        >more_horiz</span
                                    >
                                </button>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div
            class="px-6 py-4 border-t border-border-dark flex items-center justify-between shrink-0 bg-surface-darker"
        >
            <p class="text-sm text-text-secondary">Showing 1-5 of 48 tracks</p>
            <div class="flex gap-2">
                <button
                    class="size-8 flex items-center justify-center rounded border border-border-dark text-text-secondary hover:text-white hover:border-text-muted disabled:opacity-50"
                >
                    <span class="material-symbols-outlined text-lg"
                        >chevron_left</span
                    >
                </button>
                <button
                    class="size-8 flex items-center justify-center rounded border border-border-dark text-text-secondary hover:text-white hover:border-text-muted"
                >
                    <span class="material-symbols-outlined text-lg"
                        >chevron_right</span
                    >
                </button>
            </div>
        </div>
    </main>

    <!-- Right: Inspector -->
    <aside
        class="w-[420px] border-l border-border-dark bg-surface-dark flex flex-col overflow-y-auto hidden xl:flex shrink-0 shadow-xl z-20"
    >
        <div class="flex flex-col h-full">
            <div class="p-6 pb-0">
                <div class="flex items-start justify-between mb-4">
                    <h3
                        class="text-sm font-bold uppercase tracking-wider text-text-secondary"
                    >
                        Track Details
                    </h3>
                    <button class="text-text-secondary hover:text-white">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
                <div class="flex flex-col items-center text-center mb-6">
                    <div
                        class="size-32 rounded-lg shadow-lg bg-surface-darker border border-border-dark flex items-center justify-center mb-4 relative group cursor-pointer overflow-hidden"
                    >
                        {#if selectedSong.cover}
                            <img
                                src={selectedSong.cover}
                                alt={selectedSong.title}
                                class="w-full h-full object-cover"
                            />
                        {:else}
                            <span
                                class="material-symbols-outlined text-4xl opacity-20"
                                >album</span
                            >
                        {/if}
                        <div
                            class="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity rounded-lg"
                        >
                            <span
                                class="material-symbols-outlined text-white text-4xl"
                                >play_circle</span
                            >
                        </div>
                    </div>
                    <h2 class="text-xl font-bold mb-1">{selectedSong.title}</h2>
                    <p class="text-sm text-primary font-medium">
                        {selectedSong.artist}
                    </p>
                </div>

                <!-- Tabs -->
                <div class="flex border-b border-border-dark">
                    <button
                        class="flex-1 pb-3 text-sm font-medium text-text-secondary hover:text-white transition-colors"
                    >
                        Rights & Splits
                    </button>
                    <button
                        class="flex-1 pb-3 text-sm font-medium text-primary border-b-2 border-primary transition-colors"
                    >
                        Music Intelligence
                    </button>
                </div>
            </div>

            <div class="flex-1 overflow-y-auto p-6 space-y-8">
                <!-- Audio Features (Radar mock) -->
                <div>
                    <h4
                        class="font-bold mb-4 text-center text-sm uppercase tracking-wide"
                    >
                        Audio Features
                    </h4>
                    <div
                        class="relative w-48 h-48 mx-auto flex items-center justify-center border border-border-dark rounded-full"
                    >
                        <div
                            class="absolute inset-2 border border-border-dark/50 rounded-full"
                        ></div>
                        <div
                            class="absolute inset-10 border border-border-dark/50 rounded-full"
                        ></div>
                        <span
                            class="material-symbols-outlined text-primary text-4xl opacity-20"
                            >insights</span
                        >
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div
                        class="p-3 rounded-lg bg-background-dark border border-border-dark flex flex-col items-center justify-center text-center"
                    >
                        <span
                            class="text-text-secondary text-[10px] uppercase font-bold tracking-wider mb-1"
                            >Key</span
                        >
                        <div class="flex items-center gap-1">
                            <span
                                class="material-symbols-outlined text-primary text-lg"
                                >piano</span
                            >
                            <span class="text-xl font-bold">B Min</span>
                        </div>
                    </div>
                    <div
                        class="p-3 rounded-lg bg-background-dark border border-border-dark flex flex-col items-center justify-center text-center"
                    >
                        <span
                            class="text-text-secondary text-[10px] uppercase font-bold tracking-wider mb-1"
                            >Tempo</span
                        >
                        <div class="flex items-center gap-1">
                            <span
                                class="material-symbols-outlined text-primary text-lg"
                                >speed</span
                            >
                            <span class="text-xl font-bold"
                                >105 <span
                                    class="text-xs font-normal text-text-secondary"
                                    >BPM</span
                                ></span
                            >
                        </div>
                    </div>
                </div>

                <!-- Classification -->
                <div>
                    <h4 class="font-bold mb-3 text-sm">
                        Mood & Genre Classification
                    </h4>
                    <div class="space-y-4">
                        <div>
                            <div class="flex justify-between mb-1">
                                <span class="text-xs font-medium"
                                    >Synthpop / Electronic</span
                                >
                                <span class="text-xs font-bold text-primary"
                                    >94%</span
                                >
                            </div>
                            <div
                                class="w-full bg-border-dark rounded-full h-1.5 overflow-hidden"
                            >
                                <div
                                    class="bg-primary h-full"
                                    style="width: 94%"
                                ></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between mb-1">
                                <span class="text-xs font-medium"
                                    >High Energy</span
                                >
                                <span class="text-xs font-bold text-primary"
                                    >88%</span
                                >
                            </div>
                            <div
                                class="w-full bg-border-dark rounded-full h-1.5 overflow-hidden"
                            >
                                <div
                                    class="bg-primary h-full"
                                    style="width: 88%"
                                ></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Structure -->
                <div>
                    <div class="flex items-center justify-between mb-3">
                        <h4 class="font-bold text-sm">Song Structure</h4>
                        <span
                            class="text-[10px] text-text-secondary uppercase tracking-wider font-bold"
                            >4:03 Total</span
                        >
                    </div>
                    <div
                        class="relative w-full h-12 bg-background-dark rounded border border-border-dark overflow-hidden flex"
                    >
                        <div
                            class="h-full bg-primary/20 border-r border-background-dark"
                            style="width: 10%"
                        ></div>
                        <div
                            class="h-full bg-primary/40 border-r border-background-dark"
                            style="width: 25%"
                        ></div>
                        <div
                            class="h-full bg-primary border-r border-background-dark"
                            style="width: 20%"
                        ></div>
                        <div
                            class="h-full bg-primary/40 border-r border-background-dark"
                            style="width: 20%"
                        ></div>
                        <div
                            class="h-full bg-primary/60 border-r border-background-dark"
                            style="width: 15%"
                        ></div>
                        <div
                            class="h-full bg-primary/20"
                            style="width: 10%"
                        ></div>
                    </div>
                </div>
            </div>
        </div>
    </aside>
</div>
