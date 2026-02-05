<script lang="ts">
    import { fade } from "svelte/transition";
    let isAnnual = $state(false);
    let showVideo = $state(false);

    const prices = {
        artist: { monthly: 12, annual: 9 },
        label: { monthly: 49, annual: 39 },
        pro: { monthly: 199, annual: 159 },
    };
</script>

<svelte:head>
    <title>Spaza Airplay - Music Royalty Analytics for Africa</title>
</svelte:head>

<section class="w-full relative overflow-hidden">
    <!-- Background Image with Overlay -->
    <div class="absolute inset-0 z-0">
        <div
            class="absolute inset-0 bg-cover bg-center"
            style="background-image: url('https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?q=80&w=2070');"
        ></div>
        <div
            class="absolute inset-0 bg-gradient-to-r from-[#111816]/95 via-[#111816]/90 to-[#111816]/85"
        ></div>
        <div
            class="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-[#111816]"
        ></div>
    </div>

    <!-- Content -->
    <div
        class="relative z-10 px-4 py-16 md:py-24 lg:py-32 max-w-[1280px] mx-auto"
    >
        <div class="@container">
            <div class="flex flex-col gap-10 lg:flex-row lg:items-center">
                <div class="flex flex-col gap-6 lg:w-1/2 lg:pr-10">
                    <div class="flex flex-col gap-4 text-left">
                        <div
                            class="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-primary/30 bg-primary/10 backdrop-blur-sm w-fit"
                        >
                            <span
                                class="h-2 w-2 rounded-full bg-primary animate-pulse"
                            ></span>
                            <span
                                class="text-xs font-medium text-primary uppercase tracking-wide"
                                >Live Beta Available</span
                            >
                        </div>
                        <h1
                            class="text-text-main text-4xl sm:text-5xl lg:text-6xl font-black leading-tight tracking-[-0.033em] drop-shadow-2xl"
                        >
                            Real-time Royalty Transparency for <span
                                class="text-primary">African Music</span
                            >
                        </h1>
                        <h2
                            class="text-text-secondary text-lg font-normal leading-relaxed max-w-[600px]"
                        >
                            Track airplay, estimate earnings, and reconcile PRO
                            payments with the continent's most advanced
                            analytics platform.
                        </h2>
                    </div>
                    <div class="flex flex-wrap gap-4 pt-2">
                        <a
                            href="/contact"
                            class="flex items-center justify-center rounded-lg h-12 px-8 bg-primary text-[#111816] text-base font-bold hover:bg-[#0fd693] transition-all transform hover:scale-105 shadow-lg shadow-primary/20"
                        >
                            <span class="truncate">Request Early Access</span>
                        </a>
                        <button
                            onclick={() => (showVideo = true)}
                            class="flex items-center justify-center rounded-lg h-12 px-8 bg-white/10 backdrop-blur-sm border border-white/20 text-text-main text-base font-bold hover:bg-white/20 transition-all"
                        >
                            <span class="truncate">View Demo</span>
                        </button>
                    </div>
                    <div
                        class="flex items-center gap-2 text-sm text-text-secondary pt-2"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >verified</span
                        >
                        <span>Institutional Grade Auditing</span>
                        <span class="mx-2">•</span>
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >public</span
                        >
                        <span>Pan-African Coverage</span>
                    </div>

                    <!-- Stats Row -->
                    <div class="grid grid-cols-3 gap-4 pt-4">
                        <div class="flex flex-col gap-1">
                            <div
                                class="text-2xl md:text-3xl font-black text-text-main"
                            >
                                54
                            </div>
                            <div class="text-xs text-text-secondary">
                                Countries Covered
                            </div>
                        </div>
                        <div class="flex flex-col gap-1">
                            <div
                                class="text-2xl md:text-3xl font-black text-text-main"
                            >
                                2K+
                            </div>
                            <div class="text-xs text-text-secondary">
                                Radio Stations
                            </div>
                        </div>
                        <div class="flex flex-col gap-1">
                            <div
                                class="text-2xl md:text-3xl font-black text-text-main"
                            >
                                99.8%
                            </div>
                            <div class="text-xs text-text-secondary">
                                Accuracy Rate
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Social Proof Section -->
<section class="w-full border-y border-border-dark bg-surface-darker/50">
    <div class="px-4 py-10 max-w-[1280px] mx-auto text-center">
        <h3
            class="text-text-secondary text-sm font-bold uppercase tracking-widest mb-8"
        >
            Trusted by Africa’s leading artists and organizations
        </h3>
        <div
            class="flex flex-wrap justify-center items-center gap-12 md:gap-20 opacity-70 grayscale hover:grayscale-0 transition-all duration-500"
        >
            <div class="flex items-center gap-2 group cursor-default">
                <div
                    class="h-10 w-auto flex items-center justify-center font-bold text-2xl text-text-main"
                >
                    SAMRO
                </div>
            </div>
            <div class="flex items-center gap-2 group cursor-default">
                <div
                    class="h-10 w-auto flex items-center justify-center font-bold text-2xl text-text-main"
                >
                    MCSK
                </div>
            </div>
            <div class="flex items-center gap-2 group cursor-default">
                <div
                    class="h-10 w-auto flex items-center justify-center font-bold text-2xl text-text-main"
                >
                    COSON
                </div>
            </div>
            <div class="flex items-center gap-2 group cursor-default">
                <div
                    class="h-10 w-auto flex items-center justify-center font-bold text-2xl text-text-main"
                >
                    GHAMRO
                </div>
            </div>
            <div class="flex items-center gap-2 group cursor-default">
                <div
                    class="h-10 w-auto flex items-center justify-center font-bold text-2xl text-text-main"
                >
                    KAMP
                </div>
            </div>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section
    class="w-full px-4 py-24 md:py-32 max-w-[1280px] mx-auto overflow-hidden text-left"
    id="how-it-works"
>
    <div class="flex flex-col gap-12 md:gap-20">
        <div
            class="flex flex-col gap-4 text-center max-w-[800px] mx-auto relative mb-8"
        >
            <div
                class="absolute -top-12 left-1/2 -translate-x-1/2 text-primary opacity-5 text-[120px] font-black select-none pointer-events-none hidden md:block"
            >
                ROAMAP
            </div>
            <h2
                class="text-text-main text-4xl md:text-6xl font-black leading-tight tracking-tight"
            >
                Streamlined <span class="text-primary italic">Process</span>
            </h2>
            <p
                class="text-text-secondary text-lg md:text-xl font-normal leading-relaxed"
            >
                From catalog ingestion to automated reconciliation, our platform
                handles the complexity of African music rights with precision.
            </p>
        </div>

        <!-- Bento Grid Layout -->
        <div class="grid grid-cols-1 md:grid-cols-12 gap-6 md:gap-8">
            <!-- Step 1: Catalog (Large Left) -->
            <div
                class="md:col-span-12 lg:col-span-5 group relative rounded-3xl border border-white/10 bg-surface-darker/50 backdrop-blur-sm overflow-hidden p-8 hover:border-primary/30 transition-all duration-500 shadow-xl flex flex-col justify-between"
            >
                <div class="relative z-10">
                    <div class="flex items-center gap-3 mb-6">
                        <span
                            class="px-3 py-1 bg-primary/10 border border-primary/20 text-primary text-[10px] font-black rounded-full uppercase tracking-widest"
                            >Step 01</span
                        >
                    </div>
                    <h3
                        class="text-text-main text-3xl font-black mb-4 tracking-tight"
                    >
                        Catalog Integration
                    </h3>
                    <p
                        class="text-text-secondary text-base leading-relaxed mb-6"
                    >
                        Securely onboard your entire catalog with high-fidelity
                        asset indexing.
                    </p>
                    <div class="flex gap-4">
                        <div class="flex flex-col gap-1">
                            <span
                                class="text-text-main text-xs font-bold uppercase tracking-wider opacity-50"
                                >Uploads</span
                            >
                            <span
                                class="text-primary text-sm font-black underline decoration-primary/30"
                                >Bulk Support</span
                            >
                        </div>
                        <div
                            class="flex flex-col gap-1 pl-4 border-l border-white/10"
                        >
                            <span
                                class="text-text-main text-xs font-bold uppercase tracking-wider opacity-50"
                                >Metadata</span
                            >
                            <span
                                class="text-primary text-sm font-black underline decoration-primary/30"
                                >Auto-Index</span
                            >
                        </div>
                    </div>
                </div>
                <div
                    class="mt-12 relative rounded-2xl overflow-hidden border border-white/5 shadow-inner"
                >
                    <img
                        src="/images/how-it-works/step1.png"
                        alt="Catalog UI"
                        class="w-full h-auto object-cover opacity-60 group-hover:opacity-100 group-hover:scale-105 transition-all duration-700"
                    />
                    <div
                        class="absolute inset-x-0 bottom-0 h-1/2 bg-gradient-to-t from-[#111816] to-transparent"
                    ></div>
                </div>
            </div>

            <!-- Right Column Grid -->
            <div
                class="md:col-span-12 lg:col-span-7 grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8"
            >
                <!-- Step 2: Live Tracking (Top Full-width of right) -->
                <div
                    class="md:col-span-2 group relative rounded-3xl border border-white/10 bg-surface-darker overflow-hidden p-8 hover:border-primary/30 transition-all duration-500 shadow-xl min-h-[440px] flex flex-col justify-between"
                >
                    <div
                        class="relative z-10 flex flex-col md:flex-row gap-8 items-start"
                    >
                        <div class="flex-1">
                            <div class="flex items-center gap-3 mb-6">
                                <span
                                    class="px-3 py-1 bg-primary/10 border border-primary/20 text-primary text-[10px] font-black rounded-full uppercase tracking-widest"
                                    >Step 02</span
                                >
                                <span
                                    class="flex items-center gap-1.5 px-2 py-0.5 bg-red-500/10 border border-red-500/20 text-red-400 text-[9px] font-bold rounded-full uppercase tracking-tighter animate-pulse"
                                >
                                    <span
                                        class="h-1.5 w-1.5 rounded-full bg-red-500"
                                    ></span>
                                    Live
                                </span>
                            </div>
                            <h3
                                class="text-text-main text-3xl font-black mb-4 tracking-tight"
                            >
                                Broadcast Intelligence
                            </h3>
                            <p
                                class="text-text-secondary text-base leading-relaxed"
                            >
                                Our 24/7 surveillance network covers 54 African
                                countries, capturing every spin with millisecond
                                precision and 99.8% detection accuracy.
                            </p>
                            <div class="mt-8 grid grid-cols-2 gap-6">
                                <div class="flex flex-col">
                                    <span
                                        class="text-2xl font-black text-text-main"
                                        >2,000+</span
                                    >
                                    <span
                                        class="text-[10px] text-text-secondary uppercase tracking-widest font-bold"
                                        >Stations Linked</span
                                    >
                                </div>
                                <div class="flex flex-col">
                                    <span
                                        class="text-2xl font-black text-text-main"
                                        >100ms</span
                                    >
                                    <span
                                        class="text-[10px] text-text-secondary uppercase tracking-widest font-bold"
                                        >Latency Rate</span
                                    >
                                </div>
                            </div>
                        </div>
                        <div
                            class="w-full md:w-[280px] h-[200px] md:h-[280px] rounded-2xl overflow-hidden border border-white/5 relative"
                        >
                            <img
                                src="/images/how-it-works/step2.png"
                                alt="Tracking Map"
                                class="w-full h-full object-cover opacity-60 group-hover:opacity-100 transition-all duration-700"
                            />
                            <div
                                class="absolute inset-0 bg-gradient-to-tr from-[#111816]/80 to-transparent"
                            ></div>
                        </div>
                    </div>
                </div>

                <!-- Step 3: Recon (Bottom Wide) -->
                <div
                    class="md:col-span-2 group relative rounded-3xl border border-white/10 bg-[#111816] overflow-hidden p-8 hover:border-primary/40 transition-all duration-500 shadow-2xl flex flex-col md:flex-row gap-8 items-center border-l-4 border-l-primary"
                >
                    <div class="flex-1 relative z-10">
                        <div class="flex items-center gap-3 mb-6">
                            <span
                                class="px-3 py-1 bg-primary/10 border border-primary/20 text-primary text-[10px] font-black rounded-full uppercase tracking-widest"
                                >Step 03</span
                            >
                            <span
                                class="text-text-main/40 text-[10px] font-bold uppercase tracking-widest"
                                >Final Phase</span
                            >
                        </div>
                        <h3
                            class="text-text-main text-3xl font-black mb-4 tracking-tight"
                        >
                            Royalty Reconciliation
                        </h3>
                        <p
                            class="text-text-secondary text-base leading-relaxed"
                        >
                            AI-driven verification compares broadcast logs
                            against PRO statements to identify missing earnings
                            instantly.
                        </p>
                        <div class="mt-6 flex flex-wrap gap-3">
                            <span
                                class="px-3 py-1.5 bg-white/5 rounded-lg text-xs text-text-main/70 border border-white/10"
                                >PDF Export</span
                            >
                            <span
                                class="px-3 py-1.5 bg-white/5 rounded-lg text-xs text-text-main/70 border border-white/10"
                                >Discrepancy Audit</span
                            >
                            <span
                                class="px-3 py-1.5 bg-white/5 rounded-lg text-xs text-text-main/70 border border-white/10"
                                >Claim Automation</span
                            >
                        </div>
                    </div>
                    <div
                        class="w-full md:w-1/3 aspect-square rounded-2xl overflow-hidden shadow-2xl group-hover:shadow-primary/10 transition-shadow"
                    >
                        <img
                            src="/images/how-it-works/step3.png"
                            alt="Reconciliation UI"
                            class="w-full h-full object-cover opacity-70 group-hover:opacity-100 transition-opacity duration-500 group-hover:scale-110 transition-transform duration-1000"
                        />
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section
    class="w-full px-4 py-20 border-y border-border-dark bg-surface-darker/50"
    id="features"
>
    <div class="flex flex-col gap-12 max-w-[1280px] mx-auto">
        <div class="flex flex-col gap-4 text-center max-w-[720px] mx-auto">
            <h2
                class="text-text-main text-3xl md:text-4xl font-bold leading-tight"
            >
                Comprehensive Royalty Intelligence
            </h2>
            <p class="text-text-secondary text-lg font-normal">
                Empower your music career with data-driven insights tailored for
                the fragmented African market.
            </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Feature 1 -->
            <div
                class="group flex flex-col gap-4 rounded-xl border border-border-dark bg-surface-dark p-8 hover:border-primary/50 transition-colors duration-300"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-background-dark transition-colors duration-300"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">radio</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-xl font-bold">
                        Precision Airplay Monitoring
                    </h3>
                    <p class="text-text-secondary text-base leading-relaxed">
                        Monitor radio and TV spins across 54 countries in
                        real-time. Our fingerprinting technology identifies
                        usage with 99.8% accuracy.
                    </p>
                </div>
            </div>
            <!-- Feature 2 -->
            <div
                class="group flex flex-col gap-4 rounded-xl border border-border-dark bg-surface-dark p-8 hover:border-primary/50 transition-colors duration-300"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-background-dark transition-colors duration-300"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">calculate</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-xl font-bold">
                        Royalty Calculator
                    </h3>
                    <p class="text-text-secondary text-base leading-relaxed">
                        AI-driven revenue estimation based on actual airplay
                        data. Project your earnings before the check arrives.
                    </p>
                </div>
            </div>
            <!-- Feature 3 -->
            <div
                class="group flex flex-col gap-4 rounded-xl border border-border-dark bg-surface-dark p-8 hover:border-primary/50 transition-colors duration-300"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-background-dark transition-colors duration-300"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">handshake</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-xl font-bold">
                        PRO Reconciliation
                    </h3>
                    <p class="text-text-secondary text-base leading-relaxed">
                        Automated reports to compare your actual airplay against
                        PRO statements. Identify gaps and claim unpaid royalties
                        instantly.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Use Cases Section -->
<section class="w-full px-4 py-20 max-w-[1280px]">
    <div class="flex flex-col gap-12">
        <div class="flex flex-col gap-4 text-center max-w-[720px] mx-auto">
            <h2
                class="text-text-main text-3xl md:text-4xl font-bold leading-tight"
            >
                Built for Every Music Professional
            </h2>
            <p class="text-text-secondary text-lg font-normal">
                Whether you're just starting out or managing a catalog,
                RoyaltyTrack has you covered
            </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Use Case 1 -->
            <div
                class="flex gap-4 rounded-xl border border-border-dark bg-surface-dark p-6 hover:border-primary/30 transition-colors"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary flex-shrink-0"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">person</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-lg font-bold">
                        Independent Artists
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        Track your breakthrough. Monitor your airplay growth,
                        estimate earnings, and ensure you're being paid fairly
                        by PROs and distributors.
                    </p>
                </div>
            </div>
            <!-- Use Case 2 -->
            <div
                class="flex gap-4 rounded-xl border border-border-dark bg-surface-dark p-6 hover:border-primary/30 transition-colors"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary flex-shrink-0"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">groups</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-lg font-bold">
                        Managers & Producers
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        Oversee multiple artists with ease. Get consolidated
                        reports, identify trending markets, and maximize royalty
                        collection for your roster.
                    </p>
                </div>
            </div>
            <!-- Use Case 3 -->
            <div
                class="flex gap-4 rounded-xl border border-border-dark bg-surface-dark p-6 hover:border-primary/30 transition-colors"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary flex-shrink-0"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">business</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-lg font-bold">
                        Record Labels
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        Scale your operations. API access, white-label reports,
                        and bulk catalog management for hundreds or thousands of
                        tracks.
                    </p>
                </div>
            </div>
            <!-- Use Case 4 -->
            <div
                class="flex gap-4 rounded-xl border border-border-dark bg-surface-dark p-6 hover:border-primary/30 transition-colors"
            >
                <div
                    class="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary flex-shrink-0"
                >
                    <span
                        class="material-symbols-outlined"
                        style="font-size: 28px;">gavel</span
                    >
                </div>
                <div class="flex flex-col gap-2">
                    <h3 class="text-text-main text-lg font-bold">
                        Music Rights Organizations
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        Enhance transparency. Provide members with detailed
                        airplay data, reduce disputes, and improve trust in
                        royalty distribution.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Pricing Section -->
<section
    class="w-full px-4 py-24 md:py-32 border-y border-border-dark bg-surface-darker/50"
    id="pricing"
>
    <div class="flex flex-col gap-12 md:gap-16 max-w-[1280px] mx-auto">
        <div class="text-center max-w-[800px] mx-auto mb-8">
            <h2
                class="text-text-main text-4xl md:text-5xl font-black leading-tight tracking-tight mb-6"
            >
                Institutional <span class="text-primary italic"
                    >Intelligence</span
                >
            </h2>
            <p
                class="text-text-secondary text-lg md:text-xl font-normal leading-relaxed mb-10"
            >
                Choose the layer of intelligence that fits your operations
                across the African music ecosystem.
            </p>

            <!-- Billing Toggle -->
            <div class="flex items-center justify-center gap-4">
                <span
                    class="text-sm font-bold {isAnnual
                        ? 'text-text-secondary'
                        : 'text-text-main'}">Monthly</span
                >
                <button
                    class="relative w-14 h-7 rounded-full bg-surface-dark border border-border-dark p-1 transition-colors duration-300"
                    onclick={() => (isAnnual = !isAnnual)}
                >
                    <div
                        class="absolute w-5 h-5 rounded-full bg-primary shadow-lg transition-transform duration-300 {isAnnual
                            ? 'translate-x-[28px]'
                            : 'translate-x-0'}"
                    ></div>
                </button>
                <div class="flex items-center gap-2">
                    <span
                        class="text-sm font-bold {isAnnual
                            ? 'text-text-main'
                            : 'text-text-secondary'}">Annual</span
                    >
                    <span
                        class="px-2 py-0.5 rounded-full bg-primary/20 text-primary text-[10px] font-black uppercase tracking-wider"
                        >Save 20%</span
                    >
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 items-stretch">
            <!-- Artist Plan -->
            <div
                class="flex flex-col rounded-[32px] border border-white/10 bg-surface-darker p-8 hover:border-primary/20 transition-all duration-300 hover:shadow-2xl hover:shadow-primary/5"
            >
                <div class="mb-8">
                    <h3 class="text-xl font-black text-text-main mb-2">
                        Artist Elite
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        For independent creators and managers owning their
                        master rights.
                    </p>
                </div>
                <div class="mb-8 flex items-baseline gap-1">
                    <span class="text-5xl font-black text-text-main"
                        >${isAnnual
                            ? prices.artist.annual
                            : prices.artist.monthly}</span
                    >
                    <span class="text-text-secondary font-bold text-sm"
                        >/mo</span
                    >
                </div>
                <ul class="flex flex-col gap-4 mb-10 flex-1">
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Track up to 20 Songs</span>
                    </li>
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Boomplay & Mdundo Tracking</span>
                    </li>
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Daily Airplay Reports</span>
                    </li>
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Basic Reconciliation Hub</span>
                    </li>
                </ul>
                <a
                    href="/contact"
                    class="w-full py-4 rounded-xl border border-white/10 bg-white/5 text-center text-text-main font-black hover:bg-white/10 transition-all"
                    >Request Invitation</a
                >
            </div>

            <!-- Label Plan -->
            <div
                class="flex flex-col rounded-[32px] border-2 border-primary bg-surface-darker p-8 relative transform md:-translate-y-4 shadow-2xl shadow-primary/10"
            >
                <div
                    class="absolute top-0 right-8 -translate-y-1/2 bg-primary text-background-dark text-[10px] font-black px-4 py-1 rounded-full uppercase tracking-widest shadow-lg shadow-primary/20"
                >
                    Pro Standard
                </div>
                <div class="mb-8 text-left">
                    <h3 class="text-xl font-black text-text-main mb-2">
                        Label Scale
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        Comprehensive monitoring for labels and publishers with
                        large catalogs.
                    </p>
                </div>
                <div class="mb-8 flex items-baseline gap-1">
                    <span class="text-5xl font-black text-text-main"
                        >${isAnnual
                            ? prices.label.annual
                            : prices.label.monthly}</span
                    >
                    <span class="text-text-secondary font-bold text-sm"
                        >/mo</span
                    >
                </div>
                <ul class="flex flex-col gap-4 mb-10 flex-1 text-left">
                    <li class="flex items-center gap-3 text-sm text-text-main">
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span class="font-bold">500+ Radio & TV Channels</span>
                    </li>
                    <li class="flex items-center gap-3 text-sm text-text-main">
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Audiomack, Spotify, Boomplay</span>
                    </li>
                    <li class="flex items-center gap-3 text-sm text-text-main">
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Real-time Global Alerts</span>
                    </li>
                    <li class="flex items-center gap-3 text-sm text-text-main">
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>PDF Discrepancy Audits</span>
                    </li>
                    <li class="flex items-center gap-3 text-sm text-text-main">
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Advanced Market Analytics</span>
                    </li>
                </ul>
                <a
                    href="/contact"
                    class="w-full py-4 rounded-xl bg-primary text-background-dark text-center font-black hover:bg-[#0fd693] transition-all transform hover:scale-[1.02] shadow-lg shadow-primary/20"
                    >Request Invitation</a
                >
            </div>

            <!-- PRO Plan -->
            <div
                class="flex flex-col rounded-[32px] border border-white/10 bg-surface-darker p-8 hover:border-primary/20 transition-all duration-300 hover:shadow-2xl hover:shadow-primary/5"
            >
                <div class="mb-8">
                    <h3 class="text-xl font-black text-text-main mb-2">
                        CMO / PRO
                    </h3>
                    <p class="text-text-secondary text-sm leading-relaxed">
                        Institutional grade sovereignty for societies and
                        collection agencies.
                    </p>
                </div>
                <div class="mb-8 flex items-baseline gap-1">
                    <span class="text-5xl font-black text-text-main"
                        >${isAnnual
                            ? prices.pro.annual
                            : prices.pro.monthly}</span
                    >
                    <span class="text-text-secondary font-bold text-sm"
                        >/mo (Start)</span
                    >
                </div>
                <ul class="flex flex-col gap-4 mb-10 flex-1">
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>2,000+ Continental Channels</span>
                    </li>
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Full API & Data Sovereignty</span>
                    </li>
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>White-label Dispute Engine</span>
                    </li>
                    <li
                        class="flex items-center gap-3 text-sm text-text-main/80"
                    >
                        <span
                            class="material-symbols-outlined text-primary text-[18px]"
                            >check_circle</span
                        >
                        <span>Automated Distribution Audits</span>
                    </li>
                </ul>
                <a
                    href="/contact"
                    class="w-full py-4 rounded-xl border border-white/10 bg-white/5 text-center text-text-main font-black hover:bg-white/10 transition-all"
                    >Contact Sales</a
                >
            </div>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section class="w-full px-4 py-20 max-w-[1280px]" id="faq">
    <div class="flex flex-col gap-12">
        <div class="flex flex-col gap-4 text-center max-w-[720px] mx-auto">
            <h2
                class="text-text-main text-3xl md:text-4xl font-bold leading-tight"
            >
                Frequently Asked Questions
            </h2>
            <p class="text-text-secondary text-lg font-normal">
                Everything you need to know about RoyaltyTrack
            </p>
        </div>
        <div class="max-w-[800px] mx-auto w-full flex flex-col gap-4">
            <!-- FAQ 1 -->
            <details
                class="group rounded-xl border border-border-dark bg-surface-dark"
            >
                <summary
                    class="flex items-center justify-between p-6 cursor-pointer list-none"
                >
                    <span class="text-text-main font-semibold text-lg"
                        >How accurate is the airplay monitoring?</span
                    >
                    <span
                        class="material-symbols-outlined text-primary transition-transform group-open:rotate-180"
                        >expand_more</span
                    >
                </summary>
                <div class="px-6 pb-6 text-text-secondary leading-relaxed">
                    Our audio fingerprinting technology achieves 99.8% accuracy
                    in identifying tracks. We monitor stations 24/7 and
                    cross-reference multiple detection points to ensure
                    precision. Each detection is timestamped and includes
                    station metadata for complete transparency.
                </div>
            </details>
            <!-- FAQ 2 -->
            <details
                class="group rounded-xl border border-border-dark bg-surface-dark"
            >
                <summary
                    class="flex items-center justify-between p-6 cursor-pointer list-none"
                >
                    <span class="text-text-main font-semibold text-lg"
                        >Which countries and stations do you cover?</span
                    >
                    <span
                        class="material-symbols-outlined text-primary transition-transform group-open:rotate-180"
                        >expand_more</span
                    >
                </summary>
                <div class="px-6 pb-6 text-text-secondary leading-relaxed">
                    We currently monitor over 2,000 radio and TV stations across
                    all 54 African countries, plus select stations in Europe,
                    North America, and the Caribbean. Our coverage includes
                    major broadcasters like Metro FM, Hot FM, BBC, and hundreds
                    of regional stations.
                </div>
            </details>
            <!-- FAQ 3 -->
            <details
                class="group rounded-xl border border-border-dark bg-surface-dark"
            >
                <summary
                    class="flex items-center justify-between p-6 cursor-pointer list-none"
                >
                    <span class="text-text-main font-semibold text-lg"
                        >How does the PRO reconciliation work?</span
                    >
                    <span
                        class="material-symbols-outlined text-primary transition-transform group-open:rotate-180"
                        >expand_more</span
                    >
                </summary>
                <div class="px-6 pb-6 text-text-secondary leading-relaxed">
                    Upload your PRO statements (SAMRO, COSON, MCSK, etc.) and
                    our system automatically compares them against our airplay
                    data. We flag any discrepancies and generate detailed
                    reports you can submit to your PRO to claim missing
                    royalties. Many artists recover thousands in unpaid
                    earnings.
                </div>
            </details>
            <!-- FAQ 4 -->
            <details
                class="group rounded-xl border border-border-dark bg-surface-dark"
            >
                <summary
                    class="flex items-center justify-between p-6 cursor-pointer list-none"
                >
                    <span class="text-text-main font-semibold text-lg"
                        >Can I try RoyaltyTrack before committing?</span
                    >
                    <span
                        class="material-symbols-outlined text-primary transition-transform group-open:rotate-180"
                        >expand_more</span
                    >
                </summary>
                <div class="px-6 pb-6 text-text-secondary leading-relaxed">
                    Yes! Our Starter plan is completely free and lets you track
                    up to 3 songs with monthly reports. For our Professional
                    plan, we offer a 14-day free trial with full access to all
                    features, including real-time alerts and the royalty
                    calculator. No credit card required to start.
                </div>
            </details>
            <!-- FAQ 5 -->
            <details
                class="group rounded-xl border border-border-dark bg-surface-dark"
            >
                <summary
                    class="flex items-center justify-between p-6 cursor-pointer list-none"
                >
                    <span class="text-text-main font-semibold text-lg"
                        >How do I add my music to the platform?</span
                    >
                    <span
                        class="material-symbols-outlined text-primary transition-transform group-open:rotate-180"
                        >expand_more</span
                    >
                </summary>
                <div class="px-6 pb-6 text-text-secondary leading-relaxed">
                    Simply upload your audio files or provide links from
                    streaming services. You can also connect your distributor
                    account (DistroKid, TuneCore, CD Baby) to automatically
                    import your catalog. Our system creates audio fingerprints
                    and starts monitoring immediately.
                </div>
            </details>
            <!-- FAQ 6 -->
            <details
                class="group rounded-xl border border-border-dark bg-surface-dark"
            >
                <summary
                    class="flex items-center justify-between p-6 cursor-pointer list-none"
                >
                    <span class="text-text-main font-semibold text-lg"
                        >What payment methods do you accept?</span
                    >
                    <span
                        class="material-symbols-outlined text-primary transition-transform group-open:rotate-180"
                        >expand_more</span
                    >
                </summary>
                <div class="px-6 pb-6 text-text-secondary leading-relaxed">
                    We accept all major credit cards (Visa, Mastercard, Amex),
                    as well as mobile money payments (M-Pesa, MTN Mobile Money,
                    Airtel Money) for African customers. For Label/PRO plans, we
                    also offer bank transfer and invoice options.
                </div>
            </details>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="w-full py-20 bg-surface-darker border-t border-border-dark">
    <div class="max-w-[720px] mx-auto text-center flex flex-col gap-6">
        <h2
            class="text-3xl md:text-4xl font-bold text-text-main tracking-tight"
        >
            Ready to reclaim your <span class="text-primary italic"
                >royalties?</span
            >
        </h2>
        <p class="text-text-secondary text-lg">
            Join Africa's leading rights holders in the transparent music
            economy.
        </p>
        <div class="flex justify-center pt-4">
            <a
                href="/contact"
                class="flex min-w-[240px] cursor-pointer items-center justify-center rounded-xl h-14 px-8 bg-primary text-background-dark text-lg font-black hover:bg-[#0fd693] transition-all transform hover:-translate-y-1 shadow-2xl shadow-primary/10"
            >
                Request Access Now
            </a>
        </div>
    </div>
</section>

{#if showVideo}
    <!-- Video Modal Overlay -->
    <div
        class="fixed inset-0 z-[100] flex items-center justify-center p-4 md:p-10"
        transition:fade={{ duration: 200 }}
    >
        <!-- Backdrop -->
        <button
            class="absolute inset-0 bg-background-dark/95 backdrop-blur-xl cursor-default border-none outline-none"
            onclick={() => (showVideo = false)}
            aria-label="Close modal"
        ></button>

        <!-- Modal Content -->
        <div
            class="relative w-full max-w-6xl aspect-video rounded-[32px] overflow-hidden bg-black shadow-2xl border border-white/10 group"
        >
            <button
                class="absolute top-6 right-6 z-20 h-10 w-10 rounded-full bg-white/10 backdrop-blur-md border border-white/20 text-text-main flex items-center justify-center hover:bg-white/20 transition-all"
                onclick={() => (showVideo = false)}
            >
                <span class="material-symbols-outlined">close</span>
            </button>

            <!-- Video Placeholder/IFRAME -->
            <div
                class="w-full h-full flex items-center justify-center bg-surface-darker"
            >
                <div class="flex flex-col items-center gap-6">
                    <div
                        class="h-20 w-20 rounded-full bg-primary/20 flex items-center justify-center text-primary border border-primary/30"
                    >
                        <span class="material-symbols-outlined text-[40px]"
                            >play_arrow</span
                        >
                    </div>
                    <p
                        class="text-text-main text-xl font-black uppercase tracking-[0.2em] opacity-50"
                    >
                        Demo Presentation
                    </p>
                    <p class="text-text-secondary text-sm max-w-sm text-center">
                        Spaza Airplay institutional demo is loading...
                    </p>
                </div>
            </div>
        </div>
    </div>
{/if}
