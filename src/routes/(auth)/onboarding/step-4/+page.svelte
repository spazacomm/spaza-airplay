<script lang="ts">
    import { goto } from "$app/navigation";

    async function handleDashboard() {
        goto("/dashboard");
    }
</script>

<svelte:head>
    <title>Onboarding Complete | Spaza Airplay</title>
</svelte:head>

<main class="flex flex-1 justify-center py-10 px-6 lg:px-40">
    <div class="layout-content-container flex flex-col max-w-[1200px] flex-1">
        <!-- Progress Bar -->
        <div class="flex flex-col gap-3 p-4 mb-6">
            <div class="flex gap-6 justify-between">
                <p class="text-white text-base font-medium leading-normal">
                    Onboarding Complete
                </p>
                <p class="text-primary text-sm font-bold leading-normal">
                    100%
                </p>
            </div>
            <div class="rounded-full bg-white/10">
                <div
                    class="h-2 rounded-full bg-primary"
                    style="width: 100%;"
                ></div>
            </div>
            <p
                class="text-text-secondary text-xs font-normal leading-normal uppercase tracking-widest"
            >
                Step 4 of 4: Final Success
            </p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-start">
            <!-- Left Side: Welcome & Next Steps -->
            <div class="flex flex-col">
                <div
                    class="bg-primary/20 size-16 rounded-2xl flex items-center justify-center mb-6"
                >
                    <span
                        class="material-symbols-outlined text-primary text-4xl"
                        >verified</span
                    >
                </div>
                <h1
                    class="text-white tracking-light text-[36px] font-extrabold leading-tight pb-3"
                >
                    You're all set! Welcome to the future of African Music
                    Royalties.
                </h1>
                <p
                    class="text-text-secondary text-lg font-normal leading-relaxed pb-8"
                >
                    Your profile is now active. As soon as your music hits the
                    airwaves across Africa and beyond, your royalty data will
                    appear here in real-time.
                </p>
                <button
                    onclick={handleDashboard}
                    class="btn-primary flex max-w-[320px] items-center justify-center rounded-xl h-14 gap-3 text-lg font-bold leading-normal tracking-wide px-6 mb-10"
                >
                    <span>Go to My Dashboard</span>
                    <span class="material-symbols-outlined">arrow_forward</span>
                </button>
                <div class="border-t border-white/10 pt-8">
                    <h3
                        class="text-white text-lg font-bold leading-tight tracking-[-0.015em] pb-6 uppercase"
                    >
                        Next steps to maximize earnings
                    </h3>
                    <div class="flex flex-col gap-4">
                        <!-- Checklist Item 1 -->
                        <div
                            class="flex items-center gap-4 bg-white/5 p-4 rounded-xl border border-white/10 group cursor-pointer hover:border-primary/50 transition-colors"
                        >
                            <div
                                class="size-6 rounded-full border-2 border-white/20 flex items-center justify-center group-hover:border-primary"
                            >
                                <span
                                    class="material-symbols-outlined text-transparent text-sm group-hover:text-primary"
                                    >check</span
                                >
                            </div>
                            <div class="flex flex-col text-white">
                                <p class="font-medium">
                                    Invite your management team
                                </p>
                                <p class="text-text-secondary text-sm">
                                    Add up to 5 members to view analytics.
                                </p>
                            </div>
                        </div>
                        <!-- Checklist Item 2 -->
                        <div
                            class="flex items-center gap-4 bg-white/5 p-4 rounded-xl border border-white/10 group cursor-pointer hover:border-primary/50 transition-colors"
                        >
                            <div
                                class="size-6 rounded-full border-2 border-white/20 flex items-center justify-center group-hover:border-primary"
                            >
                                <span
                                    class="material-symbols-outlined text-transparent text-sm group-hover:text-primary"
                                    >check</span
                                >
                            </div>
                            <div class="flex flex-col text-white">
                                <p class="font-medium">
                                    Complete rights splits
                                </p>
                                <p class="text-text-secondary text-sm">
                                    Ensure your producers and writers are
                                    credited.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Dashboard Preview -->
            <div class="relative group">
                <div
                    class="absolute -inset-1 bg-gradient-to-r from-primary/20 to-purple-500/20 rounded-2xl blur opacity-75"
                ></div>
                <div
                    class="relative bg-surface-dark border border-white/10 rounded-2xl overflow-hidden shadow-2xl"
                >
                    <div
                        class="p-6 border-b border-white/10 flex justify-between items-center bg-white/5"
                    >
                        <h3
                            class="text-white text-sm font-bold tracking-widest uppercase"
                        >
                            Dashboard Preview
                        </h3>
                        <span
                            class="px-2 py-1 bg-primary/20 text-primary text-[10px] font-bold rounded"
                            >LIVE VIEW</span
                        >
                    </div>
                    <div
                        class="p-6 flex flex-col gap-6 grayscale-[0.5] opacity-80 pointer-events-none select-none"
                    >
                        <!-- Mock KPI Cards -->
                        <div class="grid grid-cols-2 gap-4">
                            <div
                                class="p-4 bg-white/5 rounded-xl border border-white/10"
                            >
                                <p
                                    class="text-text-secondary text-xs uppercase mb-1"
                                >
                                    Total Royalty Pool
                                </p>
                                <p class="text-2xl font-bold text-white">
                                    $142,500.00
                                </p>
                            </div>
                            <div
                                class="p-4 bg-white/5 rounded-xl border border-white/10"
                            >
                                <p
                                    class="text-text-secondary text-xs uppercase mb-1"
                                >
                                    Monthly Airplays
                                </p>
                                <p class="text-2xl font-bold text-white">
                                    1.2M
                                </p>
                            </div>
                        </div>
                    </div>
                    <!-- Blur Overlay for Teaser Effect -->
                    <div
                        class="absolute inset-0 bg-surface-darker/20 backdrop-blur-[2px] flex items-center justify-center pointer-events-none"
                    >
                        <div
                            class="bg-surface-darker/80 border border-white/20 px-4 py-2 rounded-full flex items-center gap-2"
                        >
                            <span
                                class="material-symbols-outlined text-primary text-sm"
                                >lock</span
                            >
                            <span
                                class="text-xs font-bold uppercase tracking-widest text-white/80"
                                >Connecting to Streams...</span
                            >
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
