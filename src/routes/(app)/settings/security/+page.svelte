<script lang="ts">
    import type { PageData } from "./$types";

    let { data }: { data: PageData } = $props();

    let securityLogs = $derived(data.securityLogs || []);
</script>

<svelte:head>
    <title>Account Security | Spaza Airplay</title>
</svelte:head>

<div class="max-w-4xl mx-auto py-8 px-4">
    <!-- Page Heading -->
    <div class="flex flex-wrap justify-between items-start gap-4 mb-8">
        <div class="flex flex-col gap-1">
            <h1
                class="text-text-main text-4xl font-black leading-tight tracking-tight"
            >
                Account Security
            </h1>
            <p class="text-text-secondary text-base">
                Manage your password, 2FA, and monitor recent account activity.
            </p>
        </div>
        <button
            class="flex items-center gap-2 cursor-pointer overflow-hidden rounded-xl h-10 px-4 bg-surface-dark hover:bg-white/10 text-text-main text-sm font-bold transition-all border border-white/10"
        >
            <span class="material-symbols-outlined text-sm">download</span>
            <span>Download Security Audit</span>
        </button>
    </div>

    <div class="space-y-10">
        <!-- Password Management Section -->
        <section>
            <h2 class="text-text-main text-[22px] font-bold leading-tight mb-4">
                Password Management
            </h2>
            <div class="p-6 rounded-xl bg-surface-dark border border-white/10">
                <div class="flex flex-col gap-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="flex flex-col gap-2">
                            <label class="text-sm font-medium text-text-main"
                                >Current Password</label
                            >
                            <input
                                class="bg-surface-darker border-white/10 rounded-lg text-text-main focus:ring-primary focus:border-primary p-2.5"
                                placeholder="••••••••"
                                type="password"
                            />
                        </div>
                        <div></div>
                        <div class="flex flex-col gap-2">
                            <label class="text-sm font-medium text-text-main"
                                >New Password</label
                            >
                            <input
                                class="bg-surface-darker border-white/10 rounded-lg text-text-main focus:ring-primary focus:border-primary p-2.5"
                                placeholder="••••••••"
                                type="password"
                            />
                            <!-- Password Strength Meter -->
                            <div class="flex items-center gap-2 mt-1">
                                <div
                                    class="h-1.5 flex-1 bg-white/10 rounded-full overflow-hidden"
                                >
                                    <div
                                        class="h-full bg-yellow-500 w-[65%]"
                                    ></div>
                                </div>
                                <span
                                    class="text-[10px] font-bold text-yellow-500 uppercase tracking-wider"
                                    >Strong</span
                                >
                            </div>
                        </div>
                        <div class="flex flex-col gap-2">
                            <label class="text-sm font-medium text-text-main"
                                >Confirm New Password</label
                            >
                            <input
                                class="bg-surface-darker border-white/10 rounded-lg text-text-main focus:ring-primary focus:border-primary p-2.5"
                                placeholder="••••••••"
                                type="password"
                            />
                        </div>
                    </div>
                    <div
                        class="flex flex-col md:flex-row items-center justify-between pt-4 border-t border-white/10 gap-4"
                    >
                        <p class="text-text-secondary text-xs max-w-md italic">
                            Ensure your account is using a long, random password
                            to stay secure. We recommend at least 12 characters.
                        </p>
                        <button
                            class="bg-primary hover:bg-primary/90 text-surface-darker text-sm font-bold px-6 py-2 rounded-lg transition-colors"
                            >Update Password</button
                        >
                    </div>
                </div>
            </div>
        </section>

        <!-- Two-Factor Authentication -->
        <section>
            <h2 class="text-text-main text-[22px] font-bold leading-tight mb-4">
                Two-Factor Authentication
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Auth App Card -->
                <div
                    class="p-5 rounded-xl bg-surface-dark border border-white/10 flex flex-col gap-4"
                >
                    <div class="flex items-start justify-between">
                        <div class="p-2 bg-primary/10 rounded-lg text-primary">
                            <span class="material-symbols-outlined"
                                >app_shortcut</span
                            >
                        </div>
                        <span
                            class="px-2 py-1 bg-emerald-500/10 text-emerald-500 text-[10px] font-bold rounded-full uppercase"
                            >Active</span
                        >
                    </div>
                    <div>
                        <p class="text-text-main font-bold">
                            Authenticator App
                        </p>
                        <p class="text-text-secondary text-sm leading-snug">
                            Use Google Authenticator or Authy to generate secure
                            verification codes.
                        </p>
                    </div>
                    <button
                        class="mt-2 w-full py-2 bg-white/5 hover:bg-white/10 text-text-main text-sm font-medium rounded-lg transition-colors border border-white/10 text-center"
                        >Setup App</button
                    >
                </div>
                <!-- SMS Card -->
                <div
                    class="p-5 rounded-xl bg-surface-dark border border-white/10 flex flex-col gap-4"
                >
                    <div class="flex items-start justify-between">
                        <div
                            class="p-2 bg-white/10 rounded-lg text-text-secondary"
                        >
                            <span class="material-symbols-outlined">sms</span>
                        </div>
                        <span
                            class="px-2 py-1 bg-white/5 text-text-secondary text-[10px] font-bold rounded-full uppercase"
                            >Off</span
                        >
                    </div>
                    <div>
                        <p class="text-text-main font-bold">
                            SMS Authentication
                        </p>
                        <p class="text-text-secondary text-sm leading-snug">
                            Receive a unique code via text message to your
                            registered mobile number.
                        </p>
                    </div>
                    <button
                        class="mt-2 w-full py-2 bg-primary text-surface-darker text-sm font-bold rounded-lg hover:bg-primary/90 transition-colors text-center"
                        >Enable SMS</button
                    >
                </div>
            </div>
        </section>

        <!-- Login History Table -->
        <section>
            <h2 class="text-text-main text-[22px] font-bold leading-tight mb-4">
                Login History
            </h2>
            <div
                class="rounded-xl bg-surface-dark border border-white/10 overflow-hidden"
            >
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead
                            class="bg-white/5 text-text-secondary text-xs uppercase font-bold tracking-widest"
                        >
                            <tr>
                                <th class="px-6 py-4">Date & Time</th>
                                <th class="px-6 py-4">Action</th>
                                <th class="px-6 py-4">Status</th>
                                <th class="px-6 py-4">IP Address</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-white/5 text-sm">
                            {#each securityLogs as log}
                                <tr>
                                    <td class="px-6 py-4 text-text-main"
                                        >{new Date(
                                            log.created_at,
                                        ).toLocaleString()}</td
                                    >
                                    <td
                                        class="px-6 py-4 text-text-secondary font-medium"
                                        >{log.action}</td
                                    >
                                    <td class="px-6 py-4">
                                        <span
                                            class="flex items-center gap-1.5 {log.status ===
                                            'success'
                                                ? 'text-emerald-500'
                                                : 'text-red-500'} font-bold"
                                        >
                                            <span
                                                class="size-1.5 rounded-full {log.status ===
                                                'success'
                                                    ? 'bg-emerald-500'
                                                    : 'bg-red-500'}"
                                            ></span>
                                            {log.status}
                                        </span>
                                    </td>
                                    <td
                                        class="px-6 py-4 text-text-secondary font-mono"
                                        >{log.ip_address}</td
                                    >
                                </tr>
                            {:else}
                                <tr>
                                    <td
                                        colspan="4"
                                        class="px-6 py-8 text-center text-text-secondary italic"
                                        >No recent activity detected.</td
                                    >
                                </tr>
                            {/each}
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="mt-4 flex justify-center">
                <button class="text-primary text-sm font-bold hover:underline"
                    >View All Security Logs</button
                >
            </div>
        </section>

        <!-- Danger Zone -->
        <section>
            <h2 class="text-red-500 text-[22px] font-bold leading-tight mb-4">
                Danger Zone
            </h2>
            <div
                class="rounded-xl border border-red-500/30 bg-red-500/5 p-6 flex flex-col md:flex-row items-center justify-between gap-6"
            >
                <div class="flex flex-col gap-1">
                    <p class="text-text-main font-bold">
                        Delete Account & Data
                    </p>
                    <p class="text-text-secondary text-sm max-w-lg">
                        Once you delete your account, there is no going back.
                        All your royalty earnings data, catalogs, and security
                        logs will be permanently removed.
                    </p>
                </div>
                <button
                    class="whitespace-nowrap bg-red-500 hover:bg-red-600 text-text-main font-bold px-6 py-3 rounded-lg transition-all shadow-lg shadow-red-500/20"
                    >Delete Account</button
                >
            </div>
        </section>
    </div>
</div>
