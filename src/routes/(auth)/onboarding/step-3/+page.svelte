<script lang="ts">
    import { goto } from "$app/navigation";

    async function handleContinue() {
        goto("/onboarding/step-4");
    }

    async function handleBack() {
        goto("/onboarding/step-2");
    }
</script>

<svelte:head>
    <title>Catalog Import | Spaza Airplay Onboarding</title>
</svelte:head>

<div class="p-10 max-w-5xl mx-auto w-full text-text-main">
    <!-- PageHeading -->
    <div class="mb-10 flex flex-wrap justify-between items-end gap-6">
        <div class="max-w-2xl">
            <h2 class="text-4xl font-black tracking-tight mb-2">
                Build Your Catalog
            </h2>
            <p class="text-text-secondary text-lg">
                Upload your master tracks or sync from major streaming
                platforms. Our AI will automatically detect genre, BPM, and mood
                to optimize your royalty flows.
            </p>
        </div>
        <button
            class="flex items-center gap-2 text-primary font-bold hover:underline"
        >
            <span class="material-symbols-outlined">help</span>
            View Metadata Requirements
        </button>
    </div>

    <!-- ProgressBar -->
    <div
        class="mb-12 bg-surface-dark p-6 rounded-xl border border-white/10 shadow-sm"
    >
        <div class="flex justify-between items-center mb-3">
            <span
                class="text-sm font-bold uppercase tracking-wider text-text-secondary"
                >Onboarding Progress</span
            >
            <span class="text-sm font-black text-primary">75%</span>
        </div>
        <div class="w-full bg-white/5 h-3 rounded-full overflow-hidden">
            <div
                class="bg-primary h-full transition-all duration-500"
                style="width: 75%"
            ></div>
        </div>
        <p class="mt-4 text-sm text-text-secondary flex items-center gap-2">
            <span class="material-symbols-outlined text-primary text-base"
                >info</span
            >
            Almost there! Finalizing your catalog setup is the last technical hurdle.
        </p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-2 space-y-6">
            <!-- EmptyState / Upload Zone -->
            <div
                class="border-2 border-dashed border-primary/40 bg-primary/5 rounded-xl p-12 flex flex-col items-center justify-center text-center transition-all hover:border-primary/60 hover:bg-primary/10 group cursor-pointer"
            >
                <div
                    class="size-16 rounded-full bg-primary/20 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform"
                >
                    <span
                        class="material-symbols-outlined text-primary text-3xl"
                        >cloud_upload</span
                    >
                </div>
                <h3 class="text-xl font-bold mb-2">Drag & Drop Audio Files</h3>
                <p class="text-text-secondary mb-6 max-w-sm mx-auto">
                    Support for WAV, MP3, and FLAC (Lossless preferred). Maximum
                    file size 250MB per track.
                </p>
                <div class="flex gap-3">
                    <button
                        class="btn-primary px-6 py-3 rounded-lg font-bold shadow-lg shadow-primary/20"
                    >
                        Browse Files
                    </button>
                    <button
                        class="bg-white/5 border border-white/10 px-6 py-3 rounded-lg font-bold flex items-center gap-2"
                    >
                        <span class="material-symbols-outlined text-lg"
                            >sync</span
                        >
                        Sync from Spotify
                    </button>
                </div>
            </div>

            <!-- Processing State Card -->
            <div
                class="bg-surface-dark rounded-xl border border-white/10 overflow-hidden"
            >
                <div
                    class="p-4 bg-white/5 border-b border-white/10 flex justify-between items-center"
                >
                    <span
                        class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >Processing Queue (2 Tracks)</span
                    >
                    <span class="material-symbols-outlined text-text-secondary"
                        >more_horiz</span
                    >
                </div>

                <!-- Track 1: Processing -->
                <div class="p-6 border-b border-white/10">
                    <div class="flex items-start gap-4 mb-4">
                        <div
                            class="size-12 rounded bg-surface-darker flex items-center justify-center"
                        >
                            <span class="material-symbols-outlined text-primary"
                                >audio_file</span
                            >
                        </div>
                        <div class="flex-1">
                            <div class="flex justify-between mb-1">
                                <h4 class="font-bold">
                                    Last Last_Master_v2.wav
                                </h4>
                                <span class="text-xs font-bold text-primary"
                                    >82% Analysing...</span
                                >
                            </div>
                            <div
                                class="w-full bg-white/5 h-1.5 rounded-full overflow-hidden"
                            >
                                <div
                                    class="bg-primary h-full"
                                    style="width: 82%"
                                ></div>
                            </div>
                        </div>
                    </div>
                    <div class="flex flex-wrap gap-2 pl-16">
                        <div
                            class="flex items-center gap-1 px-3 py-1 bg-primary/10 border border-primary/20 text-primary rounded-full text-[10px] font-black uppercase tracking-tighter"
                        >
                            <span class="material-symbols-outlined text-xs"
                                >auto_awesome</span
                            >
                            Afrobeats
                        </div>
                        <div
                            class="flex items-center gap-1 px-3 py-1 bg-emerald-500/10 border border-emerald-500/20 text-emerald-500 rounded-full text-[10px] font-black uppercase tracking-tighter"
                        >
                            <span class="material-symbols-outlined text-xs"
                                >timer</span
                            >
                            110 BPM
                        </div>
                        <div
                            class="flex items-center gap-1 px-3 py-1 bg-amber-500/10 border border-amber-500/20 text-amber-500 rounded-full text-[10px] font-black uppercase tracking-tighter"
                        >
                            <span class="material-symbols-outlined text-xs"
                                >music_note</span
                            >
                            A Minor
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar: Requirements -->
        <div class="space-y-6">
            <div
                class="bg-surface-dark text-text-main p-6 rounded-xl border border-white/10 shadow-xl overflow-hidden relative"
            >
                <div
                    class="absolute -top-12 -right-12 size-32 bg-primary/20 blur-3xl rounded-full"
                ></div>
                <h4
                    class="text-sm font-bold uppercase tracking-widest text-primary mb-4"
                >
                    Metadata Intelligence
                </h4>
                <p class="text-sm text-slate-300 mb-6 leading-relaxed">
                    Our platform uses <span class="text-text-main font-bold"
                        >Music Intelligence AI</span
                    > to extract attributes from your audio.
                </p>
                <ul class="space-y-4">
                    <li class="flex gap-3 items-start">
                        <span
                            class="material-symbols-outlined text-primary text-xl"
                            >payments</span
                        >
                        <span class="text-xs text-slate-300"
                            ><strong class="text-text-main block"
                                >Accurate Royalties</strong
                            > Matches ISRC codes to global reports.</span
                        >
                    </li>
                    <li class="flex gap-3 items-start">
                        <span
                            class="material-symbols-outlined text-primary text-xl"
                            >search</span
                        >
                        <span class="text-xs text-slate-300"
                            ><strong class="text-text-main block"
                                >Search Discovery</strong
                            > Auto-populates genres for curators.</span
                        >
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Action Footer -->
    <div
        class="mt-12 flex justify-between items-center pt-8 border-t border-white/10"
    >
        <button
            onclick={handleBack}
            class="flex items-center gap-2 text-text-secondary font-bold hover:text-text-main transition-colors"
        >
            <span class="material-symbols-outlined">arrow_back</span>
            Back to Rights
        </button>
        <div class="flex gap-4">
            <button
                class="px-8 py-3 rounded-lg font-bold border border-white/10 hover:bg-white/5"
            >
                Skip for now
            </button>
            <button
                onclick={handleContinue}
                class="btn-primary px-8 py-3 rounded-lg font-bold flex items-center gap-2"
            >
                Review Catalog
                <span class="material-symbols-outlined text-xl"
                    >arrow_forward</span
                >
            </button>
        </div>
    </div>
</div>
