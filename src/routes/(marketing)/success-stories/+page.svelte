<script lang="ts">
    const caseStudies = [
        {
            artist: "Sauti Sol",
            title: "Mastering the East African Airwaves",
            region: "East Africa / Global",
            plays: "120M+",
            earnings: "$450k+",
            desc: "How Kenyas top band used real-time airplay data to optimize their multi-country tour schedule and royalty collections.",
            image: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=800",
        },
        {
            artist: "Burna Boy",
            title: "The African Giant Goes Global",
            region: "Nigeria / Global",
            plays: "2B+",
            earnings: "Confidential",
            desc: "Leveraging granular metadata to ensure 100% royalty matching across 150+ international territories.",
            image: "https://images.unsplash.com/photo-1520156557489-357332da7833?q=80&w=800",
        },
    ];
</script>

<svelte:head>
    <title>Success Stories | Spaza Airplay</title>
</svelte:head>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="text-center mb-20">
        <h1
            class="text-5xl md:text-7xl font-black text-text-main mb-6 tracking-tighter"
        >
            Artist Success Stories
        </h1>
        <p
            class="text-text-secondary text-xl max-w-3xl mx-auto leading-relaxed"
        >
            Discover how the continent's biggest stars and rising talent are
            using data to claim their global legacy.
        </p>
    </div>

    <div class="space-y-24">
        {#each caseStudies as study, i}
            <section
                class="flex flex-col {i % 2 === 0
                    ? 'lg:flex-row'
                    : 'lg:flex-row-reverse'} gap-12 items-center"
            >
                <div class="flex-1 w-full lg:w-1/2">
                    <div class="relative group">
                        <div
                            class="absolute -inset-2 bg-primary/20 rounded-3xl blur-2xl opacity-0 group-hover:opacity-100 transition-opacity"
                        ></div>
                        <div
                            class="relative aspect-video rounded-3xl overflow-hidden border border-white/10 shadow-2xl"
                        >
                            <img
                                src={study.image}
                                alt={study.artist}
                                class="w-full h-full object-cover"
                            />
                            <div
                                class="absolute inset-x-0 bottom-0 bg-gradient-to-t from-surface-darker/90 to-transparent p-8"
                            >
                                <div class="flex gap-4">
                                    <div
                                        class="bg-white/10 backdrop-blur-md p-4 rounded-2xl border border-white/10"
                                    >
                                        <p
                                            class="text-[10px] uppercase font-black tracking-widest text-primary mb-1"
                                        >
                                            Total Airplays
                                        </p>
                                        <p
                                            class="text-2xl font-black text-text-main"
                                        >
                                            {study.plays}
                                        </p>
                                    </div>
                                    <div
                                        class="bg-white/10 backdrop-blur-md p-4 rounded-2xl border border-white/10"
                                    >
                                        <p
                                            class="text-[10px] uppercase font-black tracking-widest text-primary mb-1"
                                        >
                                            Royalty Growth
                                        </p>
                                        <p
                                            class="text-2xl font-black text-text-main"
                                        >
                                            ↑ 42%
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="flex-1 space-y-6">
                    <div
                        class="inline-flex px-4 py-1.5 bg-primary/10 border border-primary/20 text-primary rounded-full text-xs font-black uppercase tracking-widest"
                    >
                        {study.region}
                    </div>
                    <h2
                        class="text-4xl md:text-5xl font-black text-text-main leading-tight"
                    >
                        {study.title}
                    </h2>
                    <p class="text-text-secondary text-xl leading-relaxed">
                        {study.desc}
                    </p>
                    <div class="pt-6">
                        <button
                            class="bg-white text-surface-darker px-10 py-4 rounded-xl font-black text-lg hover:bg-primary hover:scale-105 transition-all shadow-xl shadow-white/5"
                        >
                            Read the full case study
                        </button>
                    </div>
                </div>
            </section>
        {/each}
    </div>

    <!-- CTA Section -->
    <section
        class="mt-32 p-12 md:p-24 rounded-[40px] bg-gradient-to-br from-primary to-blue-700 text-center relative overflow-hidden group"
    >
        <div
            class="absolute top-0 left-0 w-full h-full bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')] opacity-10"
        ></div>
        <div class="relative z-10 max-w-3xl mx-auto">
            <h2 class="text-4xl md:text-6xl font-black text-text-main mb-6">
                Ready to scale your legacy?
            </h2>
            <p class="text-text-main/80 text-xl md:text-2xl font-medium mb-12">
                Join the community of forward-thinking African artists
                worldwide.
            </p>
            <div class="flex flex-col sm:flex-row gap-6 justify-center">
                <button
                    class="bg-white text-primary px-12 h-16 rounded-2xl text-xl font-black hover:bg-slate-50 transition-all shadow-2xl"
                >
                    Get Started Now
                </button>
                <button
                    class="bg-primary-dark/20 backdrop-blur-md border border-white/30 text-text-main px-12 h-16 rounded-2xl text-xl font-bold hover:bg-white/10 transition-all"
                >
                    Talk to an Expert
                </button>
            </div>
        </div>
    </section>
</main>
