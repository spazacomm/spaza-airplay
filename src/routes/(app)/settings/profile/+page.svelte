<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    let profile = $derived(data.profile || {});
    let notifications = $derived(data.notifications || {});
</script>

<svelte:head>
    <title>Profile Settings | Spaza Airplay</title>
</svelte:head>

<div class="max-w-4xl mx-auto py-8 px-4">
    <!-- Page Heading -->
    <div
        class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-10"
    >
        <div>
            <h1 class="text-4xl font-black tracking-tight text-white">
                Account Settings
            </h1>
            <p class="text-text-secondary mt-2">
                Manage your artist profile, royalty IDs, and system
                notifications.
            </p>
        </div>
        <button class="btn-primary flex items-center gap-2">
            <span class="material-symbols-outlined text-[20px]">save</span>
            Save Changes
        </button>
    </div>

    <!-- Profile Header Card -->
    <div
        class="bg-surface-dark border border-white/10 rounded-xl p-6 md:p-8 mb-8"
    >
        <div class="flex flex-col md:flex-row items-center gap-8">
            <div class="relative group">
                <div
                    class="size-32 rounded-full border-4 border-primary/20 bg-center bg-cover"
                    style="background-image: url('{profile.avatar_url ||
                        'https://images.unsplash.com/photo-1531384441138-2736e62e0919?q=80&w=200'}');"
                ></div>
                <button
                    class="absolute bottom-0 right-0 p-2 bg-primary rounded-full text-surface-darker shadow-xl hover:scale-110 transition-transform"
                >
                    <span class="material-symbols-outlined text-[18px]"
                        >edit</span
                    >
                </button>
            </div>
            <div class="flex-1 text-center md:text-left">
                <h2 class="text-2xl font-bold">
                    {profile.full_name || "Your Name"}
                </h2>
                <p class="text-text-secondary text-lg">
                    Stage Name: {profile.stage_name || "N/A"}
                </p>
                <div
                    class="flex flex-wrap justify-center md:justify-start gap-4 mt-4"
                >
                    <span
                        class="px-3 py-1 bg-primary/10 text-primary text-xs font-bold rounded-full border border-primary/20 uppercase tracking-wider"
                    >
                        {profile.role || "Artist"}
                    </span>
                    <span
                        class="px-3 py-1 bg-white/10 text-text-secondary text-xs font-bold rounded-full uppercase tracking-wider"
                    >
                        {profile.plan || "Free"} Plan
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Personal Information Section -->
    <section class="mb-12">
        <div class="flex items-center gap-2 mb-6 px-2">
            <span class="material-symbols-outlined text-primary">badge</span>
            <h3 class="text-xl font-bold">Personal Information</h3>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="space-y-2">
                <label class="text-sm font-semibold text-text-secondary ml-1"
                    >Legal Name</label
                >
                <input
                    class="w-full bg-white/5 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg p-4 outline-none transition-all text-white"
                    placeholder="Full legal name"
                    type="text"
                    value={profile.legal_name || ""}
                />
            </div>
            <div class="space-y-2">
                <label class="text-sm font-semibold text-text-secondary ml-1"
                    >Stage Name</label
                >
                <input
                    class="w-full bg-white/5 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg p-4 outline-none transition-all text-white"
                    placeholder="Professional moniker"
                    type="text"
                    value={profile.stage_name || ""}
                />
            </div>
            <div class="space-y-2 md:col-span-2">
                <label class="text-sm font-semibold text-text-secondary ml-1"
                    >Email Address (Managed in Identity)</label
                >
                <input
                    class="w-full bg-white/5 border border-white/10 opacity-50 cursor-not-allowed rounded-lg p-4 outline-none text-white"
                    disabled
                    type="email"
                    value={profile.email || "user@example.com"}
                />
                <p class="text-xs text-text-secondary/60 italic px-1">
                    Contact support to change your verified account email.
                </p>
            </div>
        </div>
    </section>

    <!-- Rights Information Section -->
    <section class="mb-12">
        <div class="flex items-center gap-2 mb-6 px-2">
            <span class="material-symbols-outlined text-primary">gavel</span>
            <h3 class="text-xl font-bold">Rights Information</h3>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="space-y-2">
                <label class="text-sm font-semibold text-text-secondary ml-1"
                    >IPI Number</label
                >
                <input
                    class="w-full bg-white/5 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg p-4 outline-none transition-all text-white"
                    placeholder="Interested Party Info"
                    type="text"
                    value={profile.ipi_number || ""}
                />
            </div>
            <div class="space-y-2">
                <label class="text-sm font-semibold text-text-secondary ml-1"
                    >IPN Number</label
                >
                <input
                    class="w-full bg-white/5 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg p-4 outline-none transition-all text-white"
                    placeholder="International Performer Number"
                    type="text"
                    value={profile.ipn_number || ""}
                />
            </div>
            <div class="space-y-2">
                <label class="text-sm font-semibold text-text-secondary ml-1"
                    >Primary Territory</label
                >
                <select
                    class="w-full bg-white/5 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg p-4 outline-none transition-all text-white appearance-none"
                    value={profile.primary_territory || "ZA"}
                >
                    <option value="ZA">South Africa (SAMRO)</option>
                    <option value="NG">Nigeria (COSON/MCSN)</option>
                    <option value="KE">Kenya (MCSK)</option>
                    <option value="GH">Ghana (GHAMRO)</option>
                    <option value="GB">United Kingdom (PRS)</option>
                    <option value="US">United States (BMI)</option>
                </select>
            </div>
        </div>
    </section>

    <!-- Notifications Section -->
    <section class="mb-12">
        <div class="flex items-center gap-2 mb-6 px-2">
            <span class="material-symbols-outlined text-primary"
                >notifications_active</span
            >
            <h3 class="text-xl font-bold">Granular Notifications</h3>
        </div>
        <div
            class="bg-surface-dark border border-white/10 rounded-xl overflow-hidden divide-y divide-white/10"
        >
            <!-- Toggle Item -->
            <div
                class="flex items-center justify-between p-6 hover:bg-white/[0.02] transition-colors"
            >
                <div class="flex items-start gap-4">
                    <div class="mt-1 p-2 bg-primary/10 rounded-lg text-primary">
                        <span class="material-symbols-outlined text-[20px]"
                            >play_circle</span
                        >
                    </div>
                    <div>
                        <p class="font-bold">New Play Detected</p>
                        <p class="text-sm text-text-secondary">
                            Get real-time alerts when your track hits a major
                            streaming threshold.
                        </p>
                    </div>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input
                        type="checkbox"
                        checked={notifications.new_play_detected}
                        class="sr-only peer"
                    />
                    <div
                        class="w-11 h-6 bg-white/10 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"
                    ></div>
                </label>
            </div>

            <!-- Toggle Item -->
            <div
                class="flex items-center justify-between p-6 hover:bg-white/[0.02] transition-colors"
            >
                <div class="flex items-start gap-4">
                    <div class="mt-1 p-2 bg-primary/10 rounded-lg text-primary">
                        <span class="material-symbols-outlined text-[20px]"
                            >military_tech</span
                        >
                    </div>
                    <div>
                        <p class="font-bold">Royalty Milestone Reached</p>
                        <p class="text-sm text-text-secondary">
                            Receive push notifications for payout targets and
                            earnings spikes.
                        </p>
                    </div>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input
                        type="checkbox"
                        checked={notifications.royalty_milestone}
                        class="sr-only peer"
                    />
                    <div
                        class="w-11 h-6 bg-white/10 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"
                    ></div>
                </label>
            </div>

            <!-- Toggle Item -->
            <div
                class="flex items-center justify-between p-6 hover:bg-white/[0.02] transition-colors"
            >
                <div class="flex items-start gap-4">
                    <div class="mt-1 p-2 bg-primary/10 rounded-lg text-primary">
                        <span class="material-symbols-outlined text-[20px]"
                            >summarize</span
                        >
                    </div>
                    <div>
                        <p class="font-bold">Weekly Performance Digest</p>
                        <p class="text-sm text-text-secondary">
                            A summary email of your global performance every
                            Monday morning.
                        </p>
                    </div>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input
                        type="checkbox"
                        checked={notifications.weekly_digest}
                        class="sr-only peer"
                    />
                    <div
                        class="w-11 h-6 bg-white/10 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"
                    ></div>
                </label>
            </div>
        </div>
    </section>

    <!-- Footer Section -->
    <div
        class="flex flex-col md:flex-row justify-between items-center pt-8 border-t border-white/10 text-xs text-text-secondary"
    >
        <p>© 2024 Spaza Airplay SaaS Platform. All Rights Reserved.</p>
        <div class="flex gap-6 mt-4 md:mt-0">
            <a
                class="hover:text-primary transition-colors underline decoration-primary/30 underline-offset-4"
                href="/legal/tos">Terms of Service</a
            >
            <a
                class="hover:text-primary transition-colors underline decoration-primary/30 underline-offset-4"
                href="/legal/privacy">Privacy Policy</a
            >
        </div>
    </div>
</div>
