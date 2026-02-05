<script lang="ts">
    const categories = [
        {
            title: "Getting Started",
            icon: "rocket_launch",
            desc: "Account setup, identity verification (KYC), and first steps.",
        },
        {
            title: "Song Uploads",
            icon: "cloud_upload",
            desc: "Metadata requirements, audio formats, and ISRC codes.",
        },
        {
            title: "Understanding Splits",
            icon: "call_split",
            desc: "Managing collaborators and dividing royalty shares.",
        },
        {
            title: "PRO Integrations",
            icon: "hub",
            desc: "Connecting to SAMRO, MCSK, COSON, and more.",
        },
    ];

    const popularArticles = [
        "How to register your works with SAMRO",
        "Withdrawing your earnings to Mobile Money",
        "What is an ISRC code and why do I need one?",
        "Understanding mechanical vs performance royalties",
    ];
</script>

<svelte:head>
    <title>Help Center | Spaza Airplay</title>
</svelte:head>

<main class="flex-1">
    <!-- Hero Search Section -->
    <div
        class="px-6 lg:px-40 flex justify-center py-20 bg-gradient-to-b from-primary/5 to-transparent"
    >
        <div
            class="layout-content-container flex flex-col max-w-[960px] flex-1 text-center"
        >
            <h1
                class="text-4xl md:text-6xl font-black leading-tight tracking-tight text-text-main mb-6"
            >
                How can we help you?
            </h1>
            <p class="text-text-secondary text-lg max-w-2xl mx-auto mb-10">
                Search our knowledge base for answers on Pan-African royalties,
                splits, and global distribution.
            </p>
            <div class="w-full max-w-[640px] mx-auto">
                <div
                    class="flex items-stretch rounded-xl h-14 md:h-16 shadow-2xl bg-surface-dark border border-white/10 overflow-hidden"
                >
                    <div
                        class="flex items-center justify-center pl-4 text-text-secondary"
                    >
                        <span class="material-symbols-outlined">search</span>
                    </div>
                    <input
                        class="flex-1 bg-transparent border-none text-text-main focus:ring-0 px-4 text-base placeholder:text-text-secondary"
                        placeholder="Search for 'splits', 'ISRC', 'payouts'..."
                    />
                    <div class="flex items-center px-2">
                        <button
                            class="bg-primary text-surface-darker rounded-lg px-6 h-10 md:h-12 font-bold hover:bg-primary/90 transition-colors"
                        >
                            Search
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="px-6 lg:px-40 max-w-[960px] mx-auto py-12">
        <!-- Platform Status -->
        <div class="mb-12">
            <div
                class="flex flex-col md:flex-row md:items-center justify-between gap-4 rounded-xl border border-emerald-500/30 bg-emerald-500/5 p-5"
            >
                <div class="flex items-center gap-4">
                    <div class="relative flex h-3 w-3">
                        <span
                            class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"
                        ></span>
                        <span
                            class="relative inline-flex rounded-full h-3 w-3 bg-emerald-500"
                        ></span>
                    </div>
                    <div>
                        <p
                            class="text-emerald-500 text-base font-bold leading-tight"
                        >
                            All systems operational
                        </p>
                        <p class="text-text-secondary text-sm">
                            Royalty processing and payout systems are running
                            smoothly.
                        </p>
                    </div>
                </div>
                <button
                    class="text-sm font-bold text-primary hover:underline flex items-center gap-2"
                >
                    View detailed status
                    <span class="material-symbols-outlined text-[18px]"
                        >arrow_forward</span
                    >
                </button>
            </div>
        </div>

        <!-- Categories Grid -->
        <div class="mb-16">
            <h2 class="text-2xl font-bold text-text-main mb-8 px-2">
                Browse Categories
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {#each categories as cat}
                    <div
                        class="group cursor-pointer p-6 rounded-xl border border-white/10 bg-white/5 hover:border-primary transition-all"
                    >
                        <div
                            class="size-12 bg-primary/10 rounded-lg flex items-center justify-center mb-4 text-primary group-hover:bg-primary group-hover:text-surface-darker transition-colors"
                        >
                            <span class="material-symbols-outlined"
                                >{cat.icon}</span
                            >
                        </div>
                        <h3 class="font-bold text-lg text-text-main mb-2">
                            {cat.title}
                        </h3>
                        <p class="text-sm text-text-secondary leading-relaxed">
                            {cat.desc}
                        </p>
                    </div>
                {/each}
            </div>
        </div>

        <!-- Articles & Sidebar -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
            <div class="lg:col-span-2">
                <h2 class="text-2xl font-bold text-text-main mb-6">
                    Popular Articles
                </h2>
                <div class="space-y-4">
                    {#each popularArticles as article}
                        <button
                            class="w-full flex items-center justify-between p-4 rounded-lg bg-white/5 border border-white/10 hover:bg-white/[0.08] transition-colors group"
                        >
                            <div class="flex items-center gap-4">
                                <span
                                    class="material-symbols-outlined text-text-secondary group-hover:text-primary transition-colors"
                                    >description</span
                                >
                                <span class="font-medium text-text-main"
                                    >{article}</span
                                >
                            </div>
                            <span
                                class="material-symbols-outlined text-text-secondary"
                                >chevron_right</span
                            >
                        </button>
                    {/each}
                </div>
            </div>

            <div class="space-y-6">
                <div
                    class="bg-surface-dark p-6 rounded-xl border border-white/10 shadow-sm"
                >
                    <h3 class="text-xl font-bold text-text-main mb-2">
                        Can't find an answer?
                    </h3>
                    <p class="text-sm text-text-secondary mb-6">
                        Submit a ticket and our support team will get back to
                        you within 24 hours.
                    </p>
                    <div class="space-y-4">
                        <button
                            class="btn-primary w-full py-3 rounded-lg font-bold"
                            >Submit Ticket</button
                        >
                        <div class="flex gap-2">
                            <button
                                class="flex-1 flex items-center justify-center gap-2 py-2 border border-white/10 rounded-lg text-text-main text-sm hover:bg-white/5 transition-colors"
                            >
                                <span
                                    class="material-symbols-outlined text-[18px]"
                                    >chat</span
                                >
                                Chat
                            </button>
                            <button
                                class="flex-1 flex items-center justify-center gap-2 py-2 border border-white/10 rounded-lg text-text-main text-sm hover:bg-white/5 transition-colors"
                            >
                                <span
                                    class="material-symbols-outlined text-[18px]"
                                    >phone</span
                                >
                                Phone
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
