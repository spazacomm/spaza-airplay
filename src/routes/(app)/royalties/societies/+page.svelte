<script lang="ts">
    import { fly, fade, slide } from "svelte/transition";
    import { cubicOut } from "svelte/easing";

    // Mock Data based on royalty_societies schema
    let societies = $state([
        {
            id: "soc-001",
            name: "MCSK",
            full_name: "Music Copyright Society of Kenya",
            country: "Kenya",
            currency: "KES",
            status: "active",
            contact_info: {
                email: "info@mcsk.or.ke",
                phone: "+254 20 231 0352",
                address: "Nairobi, Kenya",
            },
        },
        {
            id: "soc-002",
            name: "KAMP",
            full_name: "Kenya Association of Music Producers",
            country: "Kenya",
            currency: "KES",
            status: "active",
            contact_info: {
                email: "info@kamp.or.ke",
                phone: "+254 722 200 111",
                address: "Nairobi, Kenya",
            },
        },
        {
            id: "soc-003",
            name: "PRISK",
            full_name: "Performers Rights Society of Kenya",
            country: "Kenya",
            currency: "KES",
            status: "active",
            contact_info: {
                email: "info@prisk.or.ke",
                phone: "+254 700 300 400",
                address: "Nairobi, Kenya",
            },
        },
        {
            id: "soc-004",
            name: "SAMRO",
            full_name: "Southern African Music Rights Organisation",
            country: "South Africa",
            currency: "ZAR",
            status: "active",
            contact_info: {
                email: "membership@samro.org.za",
                phone: "+27 11 712 8000",
                address: "Johannesburg, South Africa",
            },
        },
        {
            id: "soc-005",
            name: "UPRS",
            full_name: "Uganda Performing Right Society",
            country: "Uganda",
            currency: "UGX",
            status: "inactive",
            contact_info: {
                email: "info@uprs.ug",
                phone: "+256 414 123 456",
                address: "Kampala, Uganda",
            },
        },
    ]);

    // Enums for selection
    const cmoNames = [
        "MCSK",
        "KAMP",
        "PRISK",
        "UPRS",
        "COSOTA",
        "GHAMRO",
        "COSON",
        "MCSN",
        "SAMRO",
        "CAPASSO",
        "SAMPRA",
        "RSA",
        "SOCODA",
        "OTHER",
    ];
    const countries = [
        "Kenya",
        "Uganda",
        "Tanzania",
        "South Africa",
        "Ghana",
        "Nigeria",
        "Rwanda",
        "DRC",
    ];
    const currencies = ["KES", "UGX", "TZS", "ZAR", "GHS", "NGN", "RWF", "USD"];

    // Filters
    let searchQuery = $state("");
    let filterCountry = $state("All");
    let filterStatus = $state("All");

    // Derived filtered societies
    let filteredSocieties = $derived(
        societies.filter((s) => {
            const matchSearch =
                s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                s.full_name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                s.country.toLowerCase().includes(searchQuery.toLowerCase());
            const matchCountry =
                filterCountry === "All" || s.country === filterCountry;
            const matchStatus =
                filterStatus === "All" || s.status === filterStatus;

            return matchSearch && matchCountry && matchStatus;
        }),
    );

    // Selection & Offcanvas State
    let selectedSocietyId = $state<string | null>(null);
    let isCreateOpen = $state(false);
    let isDetailOpen = $state(false);
    let isEditMode = $state(false);

    let selectedSociety = $derived(
        societies.find((s) => s.id === selectedSocietyId),
    );

    function openDetail(id: string) {
        selectedSocietyId = id;
        isDetailOpen = true;
        isEditMode = false;
    }

    function openEdit(id: string) {
        selectedSocietyId = id;
        isDetailOpen = false;
        isCreateOpen = true;
        isEditMode = true;
        // Populate form
        if (selectedSociety) {
            newSociety = {
                name: selectedSociety.name,
                full_name: selectedSociety.full_name,
                country: selectedSociety.country,
                currency: selectedSociety.currency,
                email: selectedSociety.contact_info.email,
                phone: selectedSociety.contact_info.phone,
                address: selectedSociety.contact_info.address,
            };
        }
    }

    function closeDetail() {
        isDetailOpen = false;
        setTimeout(() => (selectedSocietyId = null), 300);
    }

    // Form State
    let newSociety = $state({
        name: "MCSK",
        full_name: "",
        country: "Kenya",
        currency: "KES",
        email: "",
        phone: "",
        address: "",
    });

    function handleSave() {
        if (isEditMode && selectedSocietyId) {
            societies = societies.map((s) =>
                s.id === selectedSocietyId
                    ? {
                          ...s,
                          name: newSociety.name,
                          full_name: newSociety.full_name,
                          country: newSociety.country,
                          currency: newSociety.currency,
                          contact_info: {
                              email: newSociety.email,
                              phone: newSociety.phone,
                              address: newSociety.address,
                          },
                      }
                    : s,
            );
        } else {
            const id = `soc-new-${Date.now()}`;
            societies = [
                {
                    id,
                    name: newSociety.name,
                    full_name: newSociety.full_name,
                    country: newSociety.country,
                    currency: newSociety.currency,
                    status: "active",
                    contact_info: {
                        email: newSociety.email,
                        phone: newSociety.phone,
                        address: newSociety.address,
                    },
                } as any,
                ...societies,
            ];
        }
        isCreateOpen = false;
        resetForm();
    }

    function resetForm() {
        newSociety = {
            name: "MCSK",
            full_name: "",
            country: "Kenya",
            currency: "KES",
            email: "",
            phone: "",
            address: "",
        };
        isEditMode = false;
    }

    function resetFilters() {
        searchQuery = "";
        filterCountry = "All";
        filterStatus = "All";
    }
</script>

<svelte:head>
    <title>Societies | Spaza Airplay</title>
</svelte:head>

<div
    class="flex flex-col h-full w-full relative bg-background-dark overflow-hidden"
>
    <!-- Header -->
    <header
        class="h-20 shrink-0 border-b border-border-dark bg-white/95 backdrop-blur-sm z-30 px-8 flex flex-col justify-center"
    >
        <!-- Breadcrumbs -->
        <nav class="flex items-center gap-2 mb-1">
            <a
                href="/dashboard"
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted hover:text-primary transition-colors"
                >Dashboard</a
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                >Royalty Management</span
            >
            <span class="material-symbols-outlined text-xs text-text-muted"
                >chevron_right</span
            >
            <span
                class="text-[10px] font-bold uppercase tracking-widest text-primary"
                >Societies</span
            >
        </nav>

        <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div
                    class="size-10 rounded-xl bg-background-dark border border-border-dark flex items-center justify-center text-primary shadow-saas-sm"
                >
                    <span class="material-symbols-outlined text-2xl"
                        >account_balance</span
                    >
                </div>
                <div>
                    <h1
                        class="text-xl font-bold text-text-primary tracking-tight leading-none"
                    >
                        Royalty Societies
                    </h1>
                    <p class="text-[10px] text-text-muted font-medium mt-1">
                        Manage CMO / PRO relationships and contact metadata
                    </p>
                </div>
            </div>

            <button
                class="h-9 px-4 btn-primary rounded-md flex items-center gap-2 shadow-saas-sm transition-all font-bold uppercase tracking-widest text-[10px]"
                onclick={() => {
                    resetForm();
                    isCreateOpen = true;
                }}
            >
                <span class="material-symbols-outlined text-lg">add</span>
                Add Society
            </button>
        </div>
    </header>

    <!-- Filters Bar -->
    <div
        class="h-14 shrink-0 border-b border-border-dark bg-white/50 px-8 flex items-center gap-4 z-20 overflow-x-auto scrollbar-none"
    >
        <!-- Search -->
        <div class="relative group min-w-[240px]">
            <span
                class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-text-muted text-lg"
                >search</span
            >
            <input
                type="text"
                placeholder="Search by name or country..."
                class="h-8 w-full bg-background-dark border border-border-dark rounded-md pl-9 pr-4 text-xs text-text-primary placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary focus:border-primary transition-all font-medium"
                bind:value={searchQuery}
            />
        </div>

        <div class="h-6 w-px bg-border-dark mx-2"></div>

        <div class="flex items-center gap-3">
            <!-- Country Filter -->
            <div class="relative group">
                <select
                    class="h-8 w-36 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterCountry}
                >
                    <option value="All">All Countries</option>
                    {#each countries as c}
                        <option value={c}>{c}</option>
                    {/each}
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >public</span
                >
            </div>

            <!-- Status Filter -->
            <div class="relative group">
                <select
                    class="h-8 w-32 appearance-none bg-background-dark border border-border-dark rounded-md pl-2.5 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary cursor-pointer hover:border-primary/30 transition-colors focus:ring-1 focus:ring-primary/20"
                    bind:value={filterStatus}
                >
                    <option value="All">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
                <span
                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-sm text-text-muted pointer-events-none"
                    >expand_more</span
                >
            </div>
        </div>

        {#if searchQuery || filterCountry !== "All" || filterStatus !== "All"}
            <button
                class="ml-auto text-[10px] text-primary font-bold uppercase tracking-widest hover:underline"
                onclick={resetFilters}
            >
                Clear Filters
            </button>
        {/if}
    </div>

    <!-- Content: Card Grid -->
    <main class="flex-1 overflow-y-auto p-8 relative">
        <div
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6"
        >
            {#each filteredSocieties as society}
                <div
                    class="group relative bg-white border border-border-dark rounded-xl p-6 hover:shadow-saas-md transition-all duration-300 hover:border-primary/30 cursor-pointer shadow-saas-sm flex flex-col justify-between overflow-hidden"
                    onclick={() => openDetail(society.id)}
                >
                    <!-- Background Shine Effect -->
                    <div
                        class="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity rounded-2xl"
                    ></div>

                    <div class="relative z-10">
                        <div class="flex justify-between items-start mb-6">
                            <div
                                class="size-14 rounded-xl bg-background-dark border border-border-dark flex items-center justify-center text-2xl font-black text-text-secondary group-hover:text-primary transition-colors shadow-inner"
                            >
                                {society.name.substring(0, 2)}
                            </div>
                            <div class="flex flex-col items-end gap-2">
                                <span
                                    class="px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest {society.status ===
                                    'active'
                                        ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20'
                                        : 'bg-red-500/10 text-red-500 border border-red-500/20'}"
                                >
                                    {society.status}
                                </span>
                            </div>
                        </div>

                        <div class="mb-6">
                            <h3
                                class="text-xl font-bold text-text-primary tracking-tight group-hover:text-primary transition-colors"
                            >
                                {society.name}
                            </h3>
                            <p
                                class="text-xs text-text-muted font-medium mt-1 line-clamp-1"
                            >
                                {society.full_name}
                            </p>
                        </div>

                        <div class="grid grid-cols-2 gap-3 mb-6">
                            <div
                                class="p-3 rounded-xl bg-surface-dark border border-border-dark"
                            >
                                <span
                                    class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                                    >Country</span
                                >
                                <div class="flex items-center gap-1.5">
                                    <span
                                        class="text-xs font-bold text-text-primary uppercase"
                                        >{society.country}</span
                                    >
                                </div>
                            </div>
                            <div
                                class="p-3 rounded-xl bg-surface-dark border border-border-dark"
                            >
                                <span
                                    class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                                    >Currency</span
                                >
                                <span
                                    class="text-xs font-mono font-bold text-text-primary"
                                    >{society.currency}</span
                                >
                            </div>
                        </div>
                    </div>

                    <div
                        class="relative z-10 pt-4 border-t border-border-dark/30 flex justify-between items-center"
                    >
                        <div class="flex items-center gap-2">
                            <span
                                class="size-2 rounded-full {society.status ===
                                'active'
                                    ? 'bg-emerald-500'
                                    : 'bg-red-500'}"
                            ></span>
                            <span
                                class="text-[10px] font-bold uppercase tracking-widest text-text-muted italic"
                                >CMO AUTHORITY</span
                            >
                        </div>
                        <button
                            class="size-8 rounded-md bg-background-dark border border-border-dark text-text-muted hover:text-primary transition-all flex items-center justify-center opacity-0 group-hover:opacity-100"
                            onclick={(e) => {
                                e.stopPropagation();
                                openEdit(society.id);
                            }}
                        >
                            <span class="material-symbols-outlined text-lg"
                                >edit</span
                            >
                        </button>
                    </div>
                </div>
            {:else}
                <div
                    class="col-span-full py-40 flex flex-col items-center justify-center opacity-30 text-center"
                >
                    <span class="material-symbols-outlined text-6xl mb-4"
                        >account_balance</span
                    >
                    <h3 class="text-xl font-bold text-text-primary">
                        No Societies Found
                    </h3>
                    <p class="text-sm">
                        Adjust your filters or register a new society.
                    </p>
                    <button
                        class="mt-4 text-xs text-primary font-bold uppercase tracking-widest hover:underline"
                        onclick={resetFilters}>Clear All Filters</button
                    >
                </div>
            {/each}
        </div>
    </main>

    <!-- Footer -->
    <footer
        class="h-10 shrink-0 border-t border-border-dark bg-white px-8 flex items-center justify-between text-[10px] font-mono text-text-muted uppercase tracking-widest"
    >
        <div>Total Registered CMOs: {filteredSocieties.length}</div>
        <div class="flex gap-4">
            <span class="flex items-center gap-1.5"
                ><span
                    class="size-2 rounded-sm bg-primary border border-primary/30"
                ></span> Global Partner</span
            >
            <span class="flex items-center gap-1.5"
                ><span
                    class="size-2 rounded-sm bg-border-dark border border-white/10"
                ></span> Local Affiliate</span
            >
        </div>
    </footer>

    <!-- Create/Edit Society Offcanvas -->
    {#if isCreateOpen}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={() => (isCreateOpen = false)}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[480px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <div class="p-6 border-b border-border-dark bg-surface-darker/50">
                <div class="flex justify-between items-start">
                    <div>
                        <h2 class="text-xl font-bold text-white tracking-tight">
                            {isEditMode
                                ? "Update Society"
                                : "Register New Society"}
                        </h2>
                        <p
                            class="text-[10px] text-text-muted font-bold uppercase tracking-widest mt-1"
                        >
                            {isEditMode
                                ? "Modify relationship metadata"
                                : "Establish a new CMO/PRO connection"}
                        </p>
                    </div>
                    <button
                        class="size-9 flex items-center justify-center rounded-xl bg-surface-dark border border-border-dark text-text-muted hover:text-white transition-all shadow-sm"
                        onclick={() => (isCreateOpen = false)}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
            </div>

            <div class="flex-1 overflow-y-auto p-8 space-y-6">
                <!-- Profile Section -->
                <div class="space-y-4">
                    <h3
                        class="text-xs font-bold text-white uppercase tracking-widest"
                    >
                        Organization Profile
                    </h3>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Short Name / Initials</label
                        >
                        <select
                            class="select w-full font-bold"
                            bind:value={newSociety.name}
                        >
                            {#each cmoNames as n}
                                <option value={n}>{n}</option>
                            {/each}
                        </select>
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Full Organization Name</label
                        >
                        <input
                            type="text"
                            class="input w-full"
                            placeholder="e.g. Music Copyright Society of Kenya"
                            bind:value={newSociety.full_name}
                        />
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Country</label
                            >
                            <select
                                class="select w-full"
                                bind:value={newSociety.country}
                            >
                                {#each countries as c}
                                    <option value={c}>{c}</option>
                                {/each}
                            </select>
                        </div>
                        <div class="space-y-1.5">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                >Base Currency</label
                            >
                            <select
                                class="select w-full font-mono"
                                bind:value={newSociety.currency}
                            >
                                {#each currencies as curr}
                                    <option value={curr}>{curr}</option>
                                {/each}
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Contact Section -->
                <div class="pt-6 border-t border-border-dark space-y-4">
                    <h3
                        class="text-xs font-bold text-white uppercase tracking-widest"
                    >
                        Contact Information
                    </h3>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Primary Email</label
                        >
                        <input
                            type="email"
                            class="input w-full"
                            placeholder="official@cmo-org.com"
                            bind:value={newSociety.email}
                        />
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Official Phone</label
                        >
                        <input
                            type="tel"
                            class="input w-full"
                            placeholder="+XX XXX XXX XXX"
                            bind:value={newSociety.phone}
                        />
                    </div>

                    <div class="space-y-1.5">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            >Headquarters Address</label
                        >
                        <textarea
                            class="textarea w-full"
                            rows="3"
                            placeholder="P.O Box 1234, Tower Building, City..."
                            bind:value={newSociety.address}
                        ></textarea>
                    </div>
                </div>
            </div>

            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 backdrop-blur-sm"
            >
                <button
                    class="w-full btn-primary py-4 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 transition-all flex items-center justify-center gap-2"
                    onclick={handleSave}
                    disabled={!newSociety.full_name}
                >
                    <span class="material-symbols-outlined"
                        >{isEditMode ? "update" : "save"}</span
                    >
                    {isEditMode
                        ? "Update Society Identity"
                        : "Submit Registration"}
                </button>
            </div>
        </aside>
    {/if}

    <!-- Detail Profile Offcanvas -->
    {#if isDetailOpen && selectedSociety}
        <div
            class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
            onclick={closeDetail}
            transition:fade={{ duration: 200 }}
        ></div>
        <aside
            class="fixed top-2 bottom-2 right-2 w-[550px] bg-surface-dark border border-border-dark/50 shadow-2xl rounded-2xl z-50 flex flex-col overflow-hidden"
            transition:fly={{
                x: 50,
                duration: 300,
                opacity: 0,
                easing: cubicOut,
            }}
        >
            <!-- Hero Header -->
            <div
                class="h-48 shrink-0 relative bg-surface-darker overflow-hidden"
            >
                <div
                    class="absolute inset-0 opacity-10 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:24px_24px]"
                ></div>
                <div
                    class="absolute inset-0 bg-gradient-to-t from-surface-darker via-transparent to-transparent"
                ></div>

                <div class="absolute top-6 right-6 z-10">
                    <button
                        class="size-9 rounded-full bg-black/40 hover:bg-black/60 backdrop-blur text-white flex items-center justify-center transition-all"
                        onclick={closeDetail}
                    >
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <div
                    class="absolute bottom-0 left-0 right-0 p-8 flex items-end gap-6"
                >
                    <div
                        class="size-20 rounded-2xl bg-surface-dark border border-border-dark flex items-center justify-center text-3xl font-black text-primary shadow-2xl transform -rotate-3"
                    >
                        {selectedSociety.name.substring(0, 2)}
                    </div>
                    <div class="flex-1 mb-1">
                        <div class="flex items-center gap-3">
                            <h2
                                class="text-3xl font-black text-white tracking-tighter"
                            >
                                {selectedSociety.name}
                            </h2>
                            <span
                                class="px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest bg-emerald-500/10 text-emerald-400 border border-emerald-500/20"
                            >
                                {selectedSociety.status}
                            </span>
                        </div>
                        <p
                            class="text-sm text-text-muted font-bold uppercase tracking-widest mt-1 opacity-70"
                        >
                            {selectedSociety.full_name}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Profile Info -->
            <div class="flex-1 overflow-y-auto p-8 space-y-8">
                <!-- Quick Stats -->
                <div class="grid grid-cols-2 gap-4">
                    <div
                        class="p-4 rounded-2xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Jurisdiction</span
                        >
                        <div class="flex items-center gap-2">
                            <span
                                class="material-symbols-outlined text-base text-primary"
                                >public</span
                            >
                            <span class="text-sm font-bold text-white uppercase"
                                >{selectedSociety.country}</span
                            >
                        </div>
                    </div>
                    <div
                        class="p-4 rounded-2xl bg-surface-darker border border-border-dark"
                    >
                        <span
                            class="text-[9px] font-bold uppercase tracking-widest text-text-muted block mb-1"
                            >Accounting Currency</span
                        >
                        <div class="flex items-center gap-2">
                            <span
                                class="material-symbols-outlined text-base text-primary"
                                >payments</span
                            >
                            <span class="text-sm font-bold text-white uppercase"
                                >{selectedSociety.currency}</span
                            >
                        </div>
                    </div>
                </div>

                <!-- Contact Details -->
                <section class="space-y-4">
                    <h3
                        class="text-xs font-bold text-white uppercase tracking-widest flex items-center gap-2"
                    >
                        <span class="material-symbols-outlined text-base"
                            >contact_mail</span
                        >
                        Official Channels
                    </h3>
                    <div
                        class="divide-y divide-border-dark/50 border border-border-dark rounded-2xl overflow-hidden bg-surface-darker/30"
                    >
                        <div
                            class="p-5 flex items-center justify-between group"
                        >
                            <div class="flex items-center gap-4">
                                <div
                                    class="size-10 rounded-xl bg-surface-dark border border-border-dark flex items-center justify-center text-text-secondary group-hover:text-primary transition-colors"
                                >
                                    <span
                                        class="material-symbols-outlined text-xl"
                                        >mail</span
                                    >
                                </div>
                                <div>
                                    <span
                                        class="text-[9px] font-bold text-text-muted uppercase tracking-wider block"
                                        >Email Address</span
                                    >
                                    <span class="text-sm font-medium text-white"
                                        >{selectedSociety.contact_info
                                            .email}</span
                                    >
                                </div>
                            </div>
                            <span
                                class="material-symbols-outlined text-text-muted text-lg opacity-0 group-hover:opacity-100 cursor-pointer"
                                >content_copy</span
                            >
                        </div>
                        <div
                            class="p-5 flex items-center justify-between group"
                        >
                            <div class="flex items-center gap-4">
                                <div
                                    class="size-10 rounded-xl bg-surface-dark border border-border-dark flex items-center justify-center text-text-secondary group-hover:text-primary transition-colors"
                                >
                                    <span
                                        class="material-symbols-outlined text-xl"
                                        >phone_in_talk</span
                                    >
                                </div>
                                <div>
                                    <span
                                        class="text-[9px] font-bold text-text-muted uppercase tracking-wider block"
                                        >Direct Line</span
                                    >
                                    <span class="text-sm font-medium text-white"
                                        >{selectedSociety.contact_info
                                            .phone}</span
                                    >
                                </div>
                            </div>
                            <span
                                class="material-symbols-outlined text-text-muted text-lg opacity-0 group-hover:opacity-100 cursor-pointer"
                                >content_copy</span
                            >
                        </div>
                        <div class="p-5 flex items-start group">
                            <div class="flex items-center gap-4">
                                <div
                                    class="size-10 rounded-xl bg-surface-dark border border-border-dark flex items-center justify-center text-text-secondary group-hover:text-primary transition-colors"
                                >
                                    <span
                                        class="material-symbols-outlined text-xl"
                                        >business</span
                                    >
                                </div>
                                <div>
                                    <span
                                        class="text-[9px] font-bold text-text-muted uppercase tracking-wider block"
                                        >Headquarters</span
                                    >
                                    <span
                                        class="text-sm font-medium text-white leading-relaxed"
                                        >{selectedSociety.contact_info
                                            .address}</span
                                    >
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Linked Activity Preview -->
                <section class="space-y-4">
                    <h3
                        class="text-xs font-bold text-white uppercase tracking-widest flex items-center gap-2"
                    >
                        <span class="material-symbols-outlined text-base"
                            >monitoring</span
                        >
                        Rates Integration
                    </h3>
                    <div
                        class="p-6 rounded-2xl bg-surface-darker border border-border-dark relative group overflow-hidden"
                    >
                        <div
                            class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"
                        ></div>
                        <div
                            class="relative z-10 flex justify-between items-center"
                        >
                            <div>
                                <span class="text-2xl font-black text-white"
                                    >12</span
                                >
                                <p
                                    class="text-[10px] text-text-muted font-bold uppercase tracking-widest mt-1"
                                >
                                    Active Rate Tables
                                </p>
                            </div>
                            <a
                                href="/royalties/rates?society={selectedSociety.name}"
                                class="btn-secondary h-9 px-4 rounded-lg flex items-center gap-2 group-hover:border-primary group-hover:text-primary transition-all"
                            >
                                <span
                                    class="text-[10px] font-bold uppercase tracking-widest"
                                    >View Engine</span
                                >
                                <span
                                    class="material-symbols-outlined text-base"
                                    >arrow_forward</span
                                >
                            </a>
                        </div>
                    </div>
                </section>
            </div>

            <!-- Footer Actions -->
            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 flex gap-3"
            >
                <button
                    class="flex-1 h-12 rounded-xl border border-border-dark bg-surface-dark text-white text-[10px] font-bold uppercase tracking-widest hover:bg-surface-darker transition-all flex items-center justify-center gap-2"
                >
                    <span class="material-symbols-outlined text-lg"
                        >history</span
                    >
                    Audit Log
                </button>
                <button
                    class="flex-1 h-12 rounded-xl btn-primary text-[10px] font-bold uppercase tracking-widest shadow-lg shadow-primary/20 flex items-center justify-center gap-2"
                    onclick={() => openEdit(selectedSociety.id)}
                >
                    <span class="material-symbols-outlined text-lg"
                        >edit_note</span
                    >
                    Configure Identity
                </button>
            </div>
        </aside>
    {/if}
</div>

<style>
    .input {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: #10b981;
        box-shadow: 0 0 0 1px rgba(16, 185, 129, 0.2);
    }
    .select {
        height: 2.75rem;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding-left: 1rem;
        padding-right: 2.5rem;
        color: #0f172a;
        font-size: 0.875rem;
        font-weight: 500;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(71, 85, 105, 1)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 0.75rem center;
        background-size: 1.25rem;
        cursor: pointer;
    }
    .textarea {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s;
        resize: none;
    }
    .textarea:focus {
        outline: none;
        border-color: #10b981;
        box-shadow: 0 0 0 1px rgba(16, 185, 129, 0.2);
    }

    /* Hide scrollbar */
    .scrollbar-none::-webkit-scrollbar {
        display: none;
    }
    .scrollbar-none {
        -ms-overflow-style: none;
        scrollbar-width: none;
    }
</style>
