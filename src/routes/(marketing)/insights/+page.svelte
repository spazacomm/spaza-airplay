<script lang="ts">
    const insights = [
        {
            title: "How to Register with SAMRO",
            category: "Education",
            readTime: "5 min",
            date: "March 14, 2024",
            image: "https://images.unsplash.com/photo-1514525253361-bee8a187499b?q=80&w=400",
            desc: "A comprehensive step-by-step guide for South African creators looking to collect their performing rights royalties.",
        },
        {
            title: "Decoding ISRC Codes",
            category: "Technical",
            readTime: "8 min",
            date: "March 10, 2024",
            image: "https://images.unsplash.com/photo-1516280440614-37939bbacd81?q=80&w=400",
            desc: "Everything you need to know about digital tracking and why your international metadata standard matters.",
        },
        {
            title: "New Licensing Deals in East Africa",
            category: "Market Trends",
            readTime: "4 min",
            date: "March 08, 2024",
            image: "https://images.unsplash.com/photo-1520156557489-357332da7833?q=80&w=400",
            desc: "Analyzing the explosive growth of streaming in Kenya and Tanzania and what it means for distribution deals.",
        },
    ];
</script>

<svelte:head>
    <title>Industry Insights | Spaza Airplay</title>
</svelte:head>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <!-- Page Header -->
    <div class="mb-12">
        <h1
            class="text-4xl md:text-5xl font-black tracking-tight mb-4 text-text-main"
        >
            Industry Insights & Education Hub
        </h1>
        <p class="text-text-secondary text-xl max-w-2xl leading-relaxed">
            Empowering African creators with data-driven research and technical
            royalty management guides.
        </p>
    </div>

    <!-- Featured Article Hero -->
    <section
        class="mb-16 group relative overflow-hidden rounded-2xl h-[480px] flex items-end"
    >
        <div
            class="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-105"
            style="background-image: linear-gradient(to top, rgba(16, 25, 34, 0.95), rgba(16, 25, 34, 0.2)), url('https://images.unsplash.com/photo-1557127318-19f6328888b6?q=80&w=1200');"
        ></div>
        <div class="relative p-8 md:p-12 w-full max-w-3xl">
            <div
                class="inline-flex items-center gap-2 bg-primary px-3 py-1 rounded-full text-xs font-bold text-surface-darker mb-4 uppercase tracking-widest"
            >
                <span class="material-symbols-outlined text-xs"
                    >auto_awesome</span
                >
                Featured Analysis
            </div>
            <h3
                class="text-text-main text-3xl md:text-5xl font-black leading-tight mb-4"
            >
                The State of Royalties in Nigeria: A 2024 Deep Dive
            </h3>
            <p class="text-slate-200 text-lg mb-6 leading-relaxed line-clamp-2">
                Nigeria's digital music revenue is projected to hit record highs
                this year. We analyze how independent artists are navigating CMO
                shifts and the rise of local streaming platforms.
            </p>
            <div class="flex items-center gap-6">
                <button
                    class="bg-white text-surface-darker px-8 py-4 rounded-xl font-bold hover:bg-primary transition-all flex items-center gap-2"
                >
                    Read Full Report
                    <span class="material-symbols-outlined"
                        >arrow_right_alt</span
                    >
                </button>
                <span class="text-text-secondary text-sm font-medium"
                    >12 min read • Market Trends</span
                >
            </div>
        </div>
    </section>

    <!-- Article Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-10">
        {#each insights as item}
            <button class="flex flex-col text-left group transition-all">
                <div
                    class="aspect-video rounded-2xl overflow-hidden mb-6 relative"
                >
                    <img
                        src={item.image}
                        alt={item.title}
                        class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                    />
                    <div
                        class="absolute top-4 left-4 bg-surface-dark/80 backdrop-blur-md px-3 py-1 rounded text-[10px] font-bold uppercase tracking-widest text-text-main border border-white/10"
                    >
                        {item.category}
                    </div>
                </div>
                <h4
                    class="text-2xl font-extrabold text-text-main leading-tight group-hover:text-primary transition-colors mb-3"
                >
                    {item.title}
                </h4>
                <p class="text-text-secondary text-base mb-6 line-clamp-3">
                    {item.desc}
                </p>
                <div
                    class="mt-auto flex items-center justify-between text-xs font-black text-text-secondary uppercase tracking-widest border-t border-white/10 pt-4"
                >
                    <span>{item.readTime} read</span>
                    <span>{item.date}</span>
                </div>
            </button>
        {/each}
    </div>

    <!-- Newsletter Section -->
    <section
        class="bg-surface-dark rounded-3xl p-8 md:p-16 mt-20 relative overflow-hidden border border-white/10"
    >
        <div
            class="absolute -right-20 -top-20 size-80 bg-primary/10 rounded-full blur-[100px]"
        ></div>
        <div
            class="relative z-10 flex flex-col items-center text-center max-w-2xl mx-auto"
        >
            <div class="p-4 bg-primary/20 rounded-2xl text-primary mb-6">
                <span class="material-symbols-outlined text-4xl">mail</span>
            </div>
            <h2 class="text-3xl md:text-5xl font-black text-text-main mb-4">
                Join 5,000+ industry professionals
            </h2>
            <p class="text-text-secondary mb-10 text-lg leading-relaxed">
                Get African music royalty insights, technical guides, and market
                shifts delivered weekly to your inbox.
            </p>
            <div class="w-full flex flex-col sm:flex-row gap-4">
                <input
                    class="flex-1 h-14 bg-surface-darker border-white/10 rounded-xl px-6 focus:ring-primary focus:border-primary text-text-main outline-none"
                    placeholder="Professional email"
                    type="email"
                />
                <button
                    class="btn-primary h-14 px-10 rounded-xl font-bold whitespace-nowrap"
                >
                    Subscribe
                </button>
            </div>
        </div>
    </section>
</main>
