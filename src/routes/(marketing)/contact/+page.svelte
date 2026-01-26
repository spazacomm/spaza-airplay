<script lang="ts">
    const offices = [
        {
            city: "Lagos, Nigeria",
            role: "Tech & Product Hub",
            addr: "24 Adeola Odeku St, Victoria Island, Lagos",
            email: "lagos@spaza.io",
            image: "https://images.unsplash.com/photo-1520156557489-357332da7833?q=80&w=400",
        },
        {
            city: "Johannesburg, SA",
            role: "Financial & Legal Hub",
            addr: "Alice Lane 3, Sandton, Johannesburg 2196",
            email: "joburg@spaza.io",
            image: "https://images.unsplash.com/photo-1514525253361-bee8a187499b?q=80&w=400",
        },
        {
            city: "Nairobi, Kenya",
            role: "East African Ops",
            addr: "Delta Corner Tower, Westlands, Nairobi",
            email: "nairobi@spaza.io",
            image: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=400",
        },
    ];
</script>

<svelte:head>
    <title>Request Early Access | Spaza Airplay</title>
</svelte:head>

<main class="flex-1">
    <section class="max-w-7xl mx-auto px-6 lg:px-10 pt-16 pb-12">
        <div
            class="relative overflow-hidden rounded-3xl bg-slate-900 aspect-[21/9] md:aspect-[3/1] flex items-center justify-center p-8 text-center border border-white/10"
            style="background-image: linear-gradient(rgba(16, 25, 34, 0.8), rgba(16, 25, 34, 0.95)), url('https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1200'); background-size: cover; background-position: center;"
        >
            <div class="max-w-3xl">
                <span
                    class="inline-block px-4 py-1.5 rounded-full bg-primary/10 border border-primary/20 text-primary text-xs font-black uppercase tracking-widest mb-6"
                    >VIP Access Only</span
                >
                <h1
                    class="text-white text-5xl md:text-7xl font-black leading-tight tracking-tighter mb-6"
                >
                    Request Early Access
                </h1>
                <p
                    class="text-slate-300 text-xl md:text-2xl font-medium leading-relaxed"
                >
                    Join the waitlist for Africa's most advanced music royalty
                    intelligence platform. Our team will review your application
                    for institutional access.
                </p>
            </div>
        </div>
    </section>

    <section
        class="max-w-7xl mx-auto px-6 lg:px-10 py-16 grid grid-cols-1 lg:grid-cols-12 gap-16"
    >
        <!-- Form -->
        <div class="lg:col-span-12 max-w-4xl mx-auto w-full">
            <div
                class="bg-surface-darker border border-white/10 rounded-[40px] p-8 md:p-16 shadow-2xl"
            >
                <form class="space-y-10">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="space-y-3">
                            <label
                                for="full_name"
                                class="text-xs font-black uppercase tracking-widest text-text-secondary ml-1"
                                >Full Name</label
                            >
                            <input
                                id="full_name"
                                class="w-full bg-[#111816] border border-white/10 rounded-2xl h-16 px-6 text-white focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all"
                                placeholder="e.g. Kofi Mensah"
                                type="text"
                            />
                        </div>
                        <div class="space-y-3">
                            <label
                                for="email"
                                class="text-xs font-black uppercase tracking-widest text-text-secondary ml-1"
                                >Work Email</label
                            >
                            <input
                                id="email"
                                class="w-full bg-[#111816] border border-white/10 rounded-2xl h-16 px-6 text-white focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all"
                                placeholder="kofi@recordlabel.africa"
                                type="email"
                            />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="space-y-3">
                            <label
                                for="sector"
                                class="text-xs font-black uppercase tracking-widest text-text-secondary ml-1"
                                >Your Sector</label
                            >
                            <select
                                id="sector"
                                class="w-full bg-[#111816] border border-white/10 rounded-2xl h-16 px-6 text-white focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all appearance-none cursor-pointer"
                            >
                                <option disabled selected value=""
                                    >Select Sector</option
                                >
                                <option value="artist"
                                    >Independent Artist</option
                                >
                                <option value="label"
                                    >Record Label / Publisher</option
                                >
                                <option value="manager">Artist Manager</option>
                                <option value="cmo">CMO / PRO (Society)</option>
                                <option value="distro">Distributor</option>
                            </select>
                        </div>
                        <div class="space-y-3">
                            <label
                                for="catalog_size"
                                class="text-xs font-black uppercase tracking-widest text-text-secondary ml-1"
                                >Catalog Size</label
                            >
                            <select
                                id="catalog_size"
                                class="w-full bg-[#111816] border border-white/10 rounded-2xl h-16 px-6 text-white focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all appearance-none cursor-pointer"
                            >
                                <option disabled selected value=""
                                    >Number of Tracks</option
                                >
                                <option value="1-10">1 - 10 Tracks</option>
                                <option value="11-100">11 - 100 Tracks</option>
                                <option value="101-1000"
                                    >101 - 1,000 Tracks</option
                                >
                                <option value="1000+">1,000+ Tracks</option>
                            </select>
                        </div>
                    </div>

                    <div class="space-y-3">
                        <label
                            for="territory"
                            class="text-xs font-black uppercase tracking-widest text-text-secondary ml-1"
                            >Primary Territory of Focus</label
                        >
                        <input
                            id="territory"
                            class="w-full bg-[#111816] border border-white/10 rounded-2xl h-16 px-6 text-white focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all"
                            placeholder="e.g. Nigeria, South Africa, East Africa, Global"
                            type="text"
                        />
                    </div>

                    <div class="space-y-3">
                        <label
                            for="message"
                            class="text-xs font-black uppercase tracking-widest text-text-secondary ml-1"
                            >How can we help? (Optional)</label
                        >
                        <textarea
                            id="message"
                            class="w-full bg-[#111816] border border-white/10 rounded-2xl p-6 text-white h-40 focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all resize-none"
                            placeholder="Tell us about your reconciliation needs..."
                        ></textarea>
                    </div>

                    <div class="pt-6">
                        <button
                            class="w-full h-16 rounded-2xl bg-primary text-background-dark text-xl font-black shadow-2xl shadow-primary/20 hover:bg-[#0fd693] transition-all transform hover:-translate-y-1"
                        >
                            Request Invite
                        </button>
                        <p class="text-center text-text-secondary text-sm mt-6">
                            By requesting access, you agree to our <a
                                href="/terms"
                                class="text-white underline">Terms</a
                            >
                            and
                            <a href="/privacy" class="text-white underline"
                                >Privacy Policy</a
                            >.
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- Office Hubs -->
    <section
        class="max-w-7xl mx-auto px-6 lg:px-10 py-24 border-t border-white/10"
    >
        <div class="text-center mb-16">
            <h2 class="text-4xl font-black text-white mb-4">
                Our Continental Hubs
            </h2>
            <p class="text-text-secondary text-xl max-w-2xl mx-auto">
                Supporting the African music ecosystem from the continent's
                major commercial centers.
            </p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            {#each offices as office}
                <div
                    class="bg-surface-dark rounded-3xl overflow-hidden border border-white/10 group hover:border-primary/50 transition-all shadow-2xl"
                >
                    <div class="h-48 relative overflow-hidden">
                        <img
                            src={office.image}
                            alt={office.city}
                            class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                        />
                        <div
                            class="absolute inset-0 bg-gradient-to-t from-surface-dark/90 to-transparent"
                        ></div>
                        <div class="absolute bottom-6 left-6">
                            <p
                                class="text-[10px] font-black uppercase tracking-widest text-primary mb-1"
                            >
                                {office.role}
                            </p>
                            <h4 class="text-2xl font-black text-white">
                                {office.city}
                            </h4>
                        </div>
                    </div>
                    <div class="p-8 space-y-6">
                        <div class="flex items-start gap-4">
                            <span class="material-symbols-outlined text-primary"
                                >pin_drop</span
                            >
                            <p
                                class="text-text-secondary text-sm leading-relaxed"
                            >
                                {office.addr}
                            </p>
                        </div>
                        <div class="flex items-center gap-4">
                            <span class="material-symbols-outlined text-primary"
                                >mail</span
                            >
                            <p class="text-text-secondary text-sm font-bold">
                                {office.email}
                            </p>
                        </div>
                    </div>
                </div>
            {/each}
        </div>
    </section>
</main>
