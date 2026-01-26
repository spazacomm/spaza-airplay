<script lang="ts">
    import { goto } from "$app/navigation";

    let proMemberships = $state([{ organization: "SAMRO", ipi: "" }]);

    function addPro() {
        proMemberships = [...proMemberships, { organization: "", ipi: "" }];
    }

    async function handleContinue() {
        goto("/onboarding/step-3");
    }

    async function handleBack() {
        goto("/onboarding/step-1");
    }
</script>

<svelte:head>
    <title>Rights Profile | Spaza Airplay Onboarding</title>
</svelte:head>

<main class="flex-1 flex flex-col items-center py-10 px-4">
    <div class="w-full max-w-[800px] flex flex-col gap-8">
        <!-- Progress Header -->
        <div class="bg-surface-dark p-6 rounded-xl border border-white/10">
            <div class="flex flex-col gap-3">
                <div class="flex gap-6 justify-between items-end">
                    <div>
                        <p
                            class="text-primary text-sm font-bold uppercase tracking-wider"
                        >
                            Step 2 of 5
                        </p>
                        <h1 class="text-2xl font-bold mt-1 text-white">
                            Rights Profile Setup
                        </h1>
                    </div>
                    <p class="text-text-secondary text-sm font-medium">
                        40% Complete
                    </p>
                </div>
                <div class="rounded-full bg-white/10 overflow-hidden h-2">
                    <div
                        class="h-full rounded-full bg-primary"
                        style="width: 40%;"
                    ></div>
                </div>
                <p class="text-text-secondary text-sm italic">
                    Linking your domestic and international performance rights
                    organizations.
                </p>
            </div>
        </div>

        <!-- Main Content Form Card -->
        <div
            class="bg-surface-dark p-8 rounded-xl border border-white/10 shadow-xl"
        >
            <div class="flex flex-col gap-8 text-white">
                <!-- Section 1: Territory -->
                <section>
                    <div class="flex items-center gap-2 mb-4">
                        <span class="material-symbols-outlined text-primary"
                            >public</span
                        >
                        <h2 class="text-xl font-bold">Primary Territory</h2>
                    </div>
                    <p class="text-text-secondary text-sm mb-4">
                        Select your primary base of operations. This helps us
                        determine your domestic royalty collection rules.
                    </p>
                    <div class="relative max-w-md">
                        <select
                            class="w-full bg-surface-darker border border-white/10 rounded-lg px-4 py-3 appearance-none focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-white"
                        >
                            <option value="ZA">South Africa (SAMRO)</option>
                            <option value="NG">Nigeria (COSON/MCSN)</option>
                            <option value="KE">Kenya (MCSK)</option>
                            <option value="GH">Ghana (GHAMRO)</option>
                            <option value="US">United States (BMI/ASCAP)</option
                            >
                            <option value="GB">United Kingdom (PRS)</option>
                        </select>
                        <div
                            class="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-text-secondary"
                        >
                            <span class="material-symbols-outlined"
                                >expand_more</span
                            >
                        </div>
                    </div>
                </section>

                <!-- Section 2: PRO Memberships -->
                <section>
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary"
                                >verified_user</span
                            >
                            <h2 class="text-xl font-bold">PRO Memberships</h2>
                        </div>
                        <span
                            class="text-xs font-medium text-text-secondary px-2 py-1 bg-white/5 rounded"
                            >IPI Required</span
                        >
                    </div>
                    <div class="flex flex-col gap-4">
                        {#each proMemberships as pro, i}
                            <div
                                class="grid grid-cols-1 md:grid-cols-2 gap-4 p-4 bg-surface-darker rounded-lg border border-white/10 relative"
                            >
                                <div class="flex flex-col gap-1.5">
                                    <label
                                        for="pro-{i}"
                                        class="text-xs font-bold text-text-secondary uppercase tracking-tight"
                                        >Organization</label
                                    >
                                    <select
                                        id="pro-{i}"
                                        class="bg-surface-dark border border-white/10 rounded px-3 py-2 text-sm focus:ring-1 focus:ring-primary outline-none"
                                    >
                                        <option>SAMRO (South Africa)</option>
                                        <option>MCSK (Kenya)</option>
                                        <option>COSON (Nigeria)</option>
                                        <option>BMI (Global/USA)</option>
                                        <option>ASCAP (Global/USA)</option>
                                    </select>
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label
                                        for="ipi-{i}"
                                        class="text-xs font-bold text-text-secondary uppercase tracking-tight flex items-center gap-1"
                                    >
                                        IPI / Member ID
                                        <span
                                            class="material-symbols-outlined text-[14px] cursor-help"
                                            title="Your 9-11 digit unique international identifier"
                                            >info</span
                                        >
                                    </label>
                                    <input
                                        id="ipi-{i}"
                                        class="bg-surface-dark border border-white/10 rounded px-3 py-2 text-sm focus:ring-1 focus:ring-primary outline-none"
                                        placeholder="e.g. 00123456789"
                                        type="text"
                                        bind:value={pro.ipi}
                                    />
                                </div>
                            </div>
                        {/each}

                        <!-- Add Another Button -->
                        <button
                            onclick={addPro}
                            class="flex items-center justify-center gap-2 py-3 border-2 border-dashed border-white/10 hover:border-primary/50 hover:bg-primary/5 transition-colors rounded-lg text-primary font-semibold text-sm"
                        >
                            <span class="material-symbols-outlined text-lg"
                                >add_circle</span
                            >
                            Add Another Organization
                        </button>
                    </div>
                </section>

                <!-- Low Friction Option -->
                <div class="pt-4 border-t border-white/10">
                    <label class="flex items-start gap-3 cursor-pointer group">
                        <div class="relative flex items-center mt-1">
                            <input
                                type="checkbox"
                                class="h-5 w-5 rounded border-white/10 bg-transparent text-primary focus:ring-primary"
                            />
                        </div>
                        <div class="flex flex-col">
                            <span class="text-sm font-semibold text-white"
                                >Verify these details later</span
                            >
                            <span class="text-xs text-text-secondary"
                                >I don't have my IPI numbers handy right now.
                                I'll provide them before my first royalty
                                payout.</span
                            >
                        </div>
                    </label>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex items-center justify-between pb-20">
            <button
                onclick={handleBack}
                class="flex items-center gap-2 px-6 py-3 font-semibold text-text-secondary hover:text-white transition-colors"
            >
                <span class="material-symbols-outlined">arrow_back</span>
                Back
            </button>
            <button
                onclick={handleContinue}
                class="btn-primary px-8 py-3 rounded-xl shadow-lg shadow-primary/20 flex items-center gap-2"
            >
                Save & Continue
                <span class="material-symbols-outlined">arrow_forward</span>
            </button>
        </div>
    </div>
</main>
