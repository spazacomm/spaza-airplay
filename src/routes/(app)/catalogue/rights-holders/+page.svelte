<script lang="ts">
    import type { PageData } from "./$types";
    import { fade, slide, fly } from "svelte/transition";
    import { createClient } from "$lib/supabase";
    import { onMount } from "svelte";
    import Modal from "$lib/components/ui/Modal.svelte";

    let { data }: { data: PageData } = $props();
    const supabase = createClient();

    // Mock Rights Holders Data
    const baseHolders = [
        {
            id: "rh-1",
            name: "Sauti Sol",
            ipi: "00123456789",
            type: "Performer",
            worksCount: 145,
            status: "Active",
            avatar: "person",
            email: "management@sautisol.com",
            phone: "+254 712 345 678",
            country: "Kenya",
        },
        {
            id: "rh-2",
            name: "Bien-Aime Baraza",
            ipi: "00654321987",
            type: "Writer",
            worksCount: 89,
            status: "Active",
            avatar: "person",
            email: "bien@solgeneration.org",
            phone: "+254 722 000 111",
            country: "Kenya",
        },
        {
            id: "rh-3",
            name: "Universal Music Africa",
            ipi: "12345678901",
            type: "Label",
            worksCount: 1240,
            status: "Active",
            avatar: "business",
            email: "legal@universalmusic.co.za",
            phone: "+27 11 000 2222",
            country: "South Africa",
        },
        {
            id: "rh-4",
            name: "Sol Generation",
            ipi: "09876543210",
            type: "Publisher",
            worksCount: 412,
            status: "Active",
            avatar: "business",
            email: "info@solgeneration.org",
            phone: "+254 733 444 555",
            country: "Kenya",
        },
    ];

    // Generate holders from DB
    let holders = $state([] as any[]);

    // Filter & Search State
    let searchQuery = $state("");
    let filterType = $state("All");
    let filterStatus = $state("All");
    let currentPage = $state(1);
    const itemsPerPage = 25;

    const filteredHolders = $derived(
        holders.filter((h) => {
            const matchesSearch =
                h.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                h.ipi.toLowerCase().includes(searchQuery.toLowerCase());

            const matchesType = filterType === "All" || h.type === filterType;
            const matchesStatus =
                filterStatus === "All" || h.status === filterStatus;

            return matchesSearch && matchesType && matchesStatus;
        }),
    );

    const paginatedHolders = $derived(
        filteredHolders.slice(
            (currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage,
        ),
    );

    let types = [
        "All",
        "Writer",
        "Performer",
        "Label",
        "Publisher",
        "Producer",
    ];
    let statuses = ["All", "Active", "Inactive", "Pending"];

    const countries = [
        "Kenya",
        "Uganda",
        "Tanzania",
        "Rwanda",
        "South Africa",
        "Nigeria",
        "Ghana",
        "Ethiopia",
        "United Kingdom",
        "United States",
    ];

    async function fetchHolders() {
        const { data: dbHolders, error } = await supabase
            .from("rights_holders")
            .select("*")
            .order("created_at", { ascending: false });

        if (error) {
            console.error("Error fetching holders:", error);
            return;
        }

        if (dbHolders) {
            holders = dbHolders.map((h) => ({
                id: h.id,
                name: h.name,
                ipi: h.ipi_number,
                type: h.type.charAt(0).toUpperCase() + h.type.slice(1),
                status: h.payment_info?.status || "Active",
                avatar:
                    h.type === "label" || h.type === "publisher"
                        ? "business"
                        : "person",
                email: h.payment_info?.email || "",
                phone: h.payment_info?.phone || "",
                country: h.payment_info?.country || "Kenya",
                worksCount: 0, // In a real app, we'd join or fetch this
            }));
        }
    }

    onMount(() => {
        fetchHolders();
    });

    function resetFilters() {
        searchQuery = "";
        filterType = "All";
        filterStatus = "All";
        currentPage = 1;
    }

    $effect(() => {
        if (searchQuery || filterType !== "All" || filterStatus !== "All") {
            currentPage = 1;
        }
    });

    // Interaction State
    let selectedHolderId = $state("");
    let isCreateOffcanvasOpen = $state(false);
    let isDeleteModalOpen = $state(false);

    // Tab & Edit State
    let activeTab = $state("details"); // 'details', 'works', 'recordings'
    let isEditing = $state(false);
    let editingHolder = $state({} as any);

    const selectedHolder = $derived(
        holders.find((h) => h.id === selectedHolderId),
    );

    function openDetails(id: string) {
        selectedHolderId = id;
        activeTab = "details";
        isEditing = false;
        if (selectedHolder) {
            editingHolder = { ...selectedHolder };
        }
    }

    function closeDetails() {
        selectedHolderId = "";
        isEditing = false;
    }

    function toggleEdit() {
        if (isEditing) {
            // Cancel edit
            if (selectedHolder) editingHolder = { ...selectedHolder };
            isEditing = false;
        } else {
            if (selectedHolder) editingHolder = { ...selectedHolder };
            isEditing = true;
        }
    }

    async function saveEdit() {
        const { error } = await supabase
            .from("rights_holders")
            .update({
                name: editingHolder.name,
                ipi_number: editingHolder.ipi,
                type: editingHolder.type.toLowerCase(),
                payment_info: {
                    ...editingHolder.payment_info,
                    email: editingHolder.email,
                    phone: editingHolder.phone,
                    country: editingHolder.country,
                    status: editingHolder.status,
                },
            })
            .eq("id", selectedHolderId);

        if (error) {
            console.error("Error updating holder:", error);
            return;
        }

        holders = holders.map((h) =>
            h.id === selectedHolderId ? { ...editingHolder } : h,
        );
        isEditing = false;
    }

    function handleDelete() {
        isDeleteModalOpen = true;
    }

    async function confirmDelete() {
        const { error } = await supabase
            .from("rights_holders")
            .delete()
            .eq("id", selectedHolderId);

        if (error) {
            console.error("Error deleting holder:", error);
            // In a real app we'd show a toast here
            return;
        }

        holders = holders.filter((h) => h.id !== selectedHolderId);
        closeDetails();
    }

    // Mock Works & Recordings for Tabs
    const mockWorks = [
        { id: "w-1", title: "Mazishi", role: "composer", share: 100 },
        { id: "w-2", title: "Sura Yako", role: "composer", share: 25 },
        { id: "w-3", title: "Melanin", role: "composer", share: 25 },
    ];

    const mockRecordings = [
        {
            id: "r-1",
            title: "Mazishi (Original Mix)",
            isrc: "KE-A12-20-00001",
            role: "performer",
            share: 80,
        },
        {
            id: "r-2",
            title: "Sura Yako",
            isrc: "KE-A12-14-12345",
            role: "performer",
            share: 25,
        },
    ];

    // Create Logic
    let newHolder = $state({
        name: "",
        ipi: "",
        type: "Writer",
        email: "",
        phone: "",
        country: "Kenya",
    });

    async function handleAddHolder() {
        const { data: insertedData, error } = await supabase
            .from("rights_holders")
            .insert({
                name: newHolder.name,
                ipi_number: newHolder.ipi,
                type: newHolder.type.toLowerCase(),
                payment_info: {
                    email: newHolder.email,
                    phone: newHolder.phone,
                    country: newHolder.country,
                    status: "Active",
                },
            })
            .select()
            .single();

        if (error) {
            console.error("Error adding holder:", error);
            return;
        }

        if (insertedData) {
            const added = {
                id: insertedData.id,
                name: insertedData.name,
                ipi: insertedData.ipi_number,
                type:
                    insertedData.type.charAt(0).toUpperCase() +
                    insertedData.type.slice(1),
                status: "Active",
                avatar:
                    insertedData.type === "label" ||
                    insertedData.type === "publisher"
                        ? "business"
                        : "person",
                email: insertedData.payment_info?.email || "",
                phone: insertedData.payment_info?.phone || "",
                country: insertedData.payment_info?.country || "Kenya",
                worksCount: 0,
            };
            holders = [added, ...holders];
        }

        newHolder = {
            name: "",
            ipi: "",
            type: "Writer",
            email: "",
            phone: "",
            country: "Kenya",
        };
        isCreateOffcanvasOpen = false;
    }
</script>

<svelte:head>
    <title>Rights Holders | Spaza Airplay</title>
</svelte:head>

<div class="flex flex-col min-h-full w-full max-w-full relative">
    <main class="flex-1 flex flex-col min-w-0 bg-surface-darker">
        <!-- Page Header -->
        <div
            class="bg-surface-dark border-b border-border-dark shadow-sm sticky top-0 z-30"
        >
            <!-- Title Section -->
            <div class="px-6 py-5 border-b border-border-dark/50">
                <div class="max-w-[1600px] mx-auto">
                    <nav
                        class="flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest text-text-muted mb-3"
                    >
                        <a
                            href="/dashboard"
                            class="hover:text-primary transition-colors">Home</a
                        >
                        <span class="text-border-dark">/</span>
                        <span class="text-text-secondary">Catalog</span>
                    </nav>
                    <div class="space-y-1">
                        <h1
                            class="text-2xl font-bold tracking-tight text-text-main leading-none"
                        >
                            Rights Holders
                        </h1>
                        <p class="text-xs text-text-secondary font-medium">
                            Manage entities, IPI numbers, and distribution roles
                            across your catalog.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Toolbar Section -->
            <div class="px-6 py-2 bg-surface-darker/50 backdrop-blur-sm">
                <div
                    class="flex flex-col md:flex-row items-center justify-between gap-4"
                >
                    <div
                        class="flex flex-col md:flex-row gap-2 items-center flex-1 w-full"
                    >
                        <div class="relative flex-1 w-full max-w-md">
                            <span
                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-base"
                                >search</span
                            >
                            <input
                                type="text"
                                placeholder="Search by name or IPI..."
                                class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-9 pr-4 text-xs text-text-main placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary/40 focus:border-primary/40 transition-all"
                                bind:value={searchQuery}
                            />
                        </div>

                        <div class="flex items-center gap-2 w-full md:w-auto">
                            <div class="relative min-w-[130px]">
                                <select
                                    class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-3 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary hover:border-border-muted transition-colors appearance-none cursor-pointer"
                                    bind:value={filterType}
                                >
                                    {#each types as t}
                                        <option value={t}
                                            >{t === "All"
                                                ? "All Types"
                                                : t}</option
                                        >
                                    {/each}
                                </select>
                                <span
                                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-base text-text-muted pointer-events-none"
                                    >expand_more</span
                                >
                            </div>

                            <div class="relative min-w-[130px]">
                                <select
                                    class="w-full bg-surface-darker/80 border border-border-dark rounded-md py-1.5 pl-3 pr-8 text-[10px] font-bold uppercase tracking-wider text-text-secondary hover:border-border-muted transition-colors appearance-none cursor-pointer"
                                    bind:value={filterStatus}
                                >
                                    {#each statuses as s}
                                        <option value={s}
                                            >{s === "All"
                                                ? "All Status"
                                                : s}</option
                                        >
                                    {/each}
                                </select>
                                <span
                                    class="material-symbols-outlined absolute right-2 top-1/2 -translate-y-1/2 text-base text-text-muted pointer-events-none"
                                    >expand_more</span
                                >
                            </div>

                            <button
                                class="p-1.5 rounded-md text-text-muted hover:text-text-main hover:bg-surface-dark transition-all"
                                onclick={resetFilters}
                                title="Reset Filters"
                            >
                                <span
                                    class="material-symbols-outlined text-base"
                                    >refresh</span
                                >
                            </button>
                        </div>
                    </div>

                    <button
                        class="btn-primary py-1.5 px-4 text-[10px] font-bold uppercase tracking-wider flex items-center gap-2 shadow-lg shadow-primary/5 w-full md:w-auto justify-center"
                        onclick={() => (isCreateOffcanvasOpen = true)}
                    >
                        <span class="material-symbols-outlined text-base"
                            >person_add</span
                        >
                        Add Rights Holder
                    </button>
                </div>
            </div>
        </div>

        <!-- Table Area -->
        <div class="flex-1 pb-6">
            <div
                class="overflow-auto max-h-[calc(100vh-280px)] bg-white border-t border-slate-200"
            >
                <table class="table-enterprise">
                    <thead>
                        <tr>
                            <th>Holder Name</th>
                            <th>IPI Number</th>
                            <th>Primary Type</th>
                            <th class="text-center">Status</th>
                            <th class="w-10"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-dark/50">
                        {#each paginatedHolders as holder (holder.id)}
                            <tr
                                class="table-row group relative cursor-pointer"
                                class:table-row-active={selectedHolderId ===
                                    holder.id}
                                onclick={() => openDetails(holder.id)}
                            >
                                {#if selectedHolderId === holder.id}
                                    <td
                                        class="absolute left-0 top-0 bottom-0 w-1 bg-primary"
                                    ></td>
                                {/if}
                                <td class="py-3 px-4">
                                    <p
                                        class="font-semibold text-sm text-text-primary tracking-tight group-hover:text-primary transition-colors"
                                    >
                                        {holder.name}
                                    </p>
                                </td>
                                <td
                                    class="py-4 px-6 text-xs font-mono text-text-secondary tracking-tighter"
                                    >{holder.ipi}</td
                                >
                                <td class="py-4 px-6">
                                    <span
                                        class="px-2 py-0.5 rounded-full text-[9px] font-bold uppercase tracking-widest bg-surface-darker border border-border-dark text-text-secondary"
                                    >
                                        {holder.type}
                                    </span>
                                </td>

                                <td class="py-4 px-6 text-center">
                                    <span
                                        class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-widest {holder.status ===
                                        'Active'
                                            ? 'bg-emerald-500/10 text-emerald-400'
                                            : 'bg-amber-500/10 text-amber-400'}"
                                    >
                                        {holder.status}
                                    </span>
                                </td>
                                <td class="py-4 px-6 text-right">
                                    <button
                                        class="size-8 flex items-center justify-center rounded-lg text-text-muted hover:text-text-main hover:bg-surface-dark transition-all"
                                    >
                                        <span
                                            class="material-symbols-outlined text-lg"
                                            >edit_note</span
                                        >
                                    </button>
                                </td>
                            </tr>
                        {:else}
                            <tr>
                                <td colspan="6" class="py-20 text-center">
                                    <div
                                        class="flex flex-col items-center gap-3 text-text-muted"
                                    >
                                        <span
                                            class="material-symbols-outlined text-5xl opacity-20"
                                            >person_off</span
                                        >
                                        <p class="text-sm font-medium">
                                            No rights holders found
                                        </p>
                                        <button
                                            class="text-xs text-primary hover:underline font-bold uppercase tracking-widest"
                                            onclick={resetFilters}
                                            >Clear all filters</button
                                        >
                                    </div>
                                </td>
                            </tr>
                        {/each}
                    </tbody>
                </table>
            </div>

            <!-- Pagination Bar -->
            <div
                class="sticky bottom-0 bg-surface-darker/95 backdrop-blur-md border-t border-border-dark px-6 py-4 flex items-center justify-between z-20 shadow-[0_-10px_30px_rgba(0,0,0,0.3)]"
            >
                <p
                    class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
                >
                    Showing <span class="text-text-main"
                        >{paginatedHolders.length}</span
                    >
                    of
                    <span class="text-text-main">{filteredHolders.length}</span>
                    holders
                </p>
                <div class="flex items-center gap-6">
                    <span
                        class="text-[11px] font-bold uppercase tracking-widest text-text-muted"
                    >
                        Page <span class="text-text-main">{currentPage}</span> / {Math.ceil(
                            filteredHolders.length / itemsPerPage,
                        ) || 1}
                    </span>
                    <div class="flex gap-2">
                        <button
                            class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-text-main hover:bg-primary/5 transition-all disabled:opacity-20"
                            onclick={() =>
                                (currentPage = Math.max(1, currentPage - 1))}
                            disabled={currentPage === 1}
                        >
                            <span class="material-symbols-outlined text-xl"
                                >chevron_left</span
                            >
                        </button>
                        <button
                            class="size-9 flex items-center justify-center rounded-lg border border-border-dark text-text-muted hover:text-text-main hover:bg-primary/5 transition-all disabled:opacity-20"
                            onclick={() =>
                                (currentPage = Math.min(
                                    Math.ceil(
                                        filteredHolders.length / itemsPerPage,
                                    ),
                                    currentPage + 1,
                                ))}
                            disabled={currentPage ===
                                Math.ceil(
                                    filteredHolders.length / itemsPerPage,
                                ) || filteredHolders.length === 0}
                        >
                            <span class="material-symbols-outlined text-xl"
                                >chevron_right</span
                            >
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Detail View Offcanvas -->
    {#if selectedHolder}
        <div
            class="offcanvas-backdrop"
            role="button"
            tabindex="0"
            aria-label="Close panel"
            onclick={closeDetails}
            onkeydown={(e) => e.key === "Escape" && closeDetails()}
        ></div>
        <aside
            class="offcanvas-panel"
            transition:fly={{ x: 480, duration: 300, opacity: 1 }}
        >
            <div class="offcanvas-header pb-0 border-b-0">
                <div class="flex items-center justify-between w-full">
                    <div class="flex items-center gap-3">
                        <div class="offcanvas-header-icon">
                            <span class="material-symbols-outlined">person</span
                            >
                        </div>
                        <div>
                            <h2 class="offcanvas-title">Holder Profile</h2>
                            <p class="offcanvas-subtitle">Registry Info</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-2">
                        {#if !isEditing}
                            <button
                                class="btn-primary py-1 px-3 text-[10px] font-bold uppercase tracking-widest flex items-center gap-1.5"
                                onclick={toggleEdit}
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >edit</span
                                >
                                Edit
                            </button>
                            <button
                                class="px-3 py-1 rounded border border-red-500/20 bg-red-500/5 text-red-500 text-[10px] font-bold uppercase tracking-widest hover:bg-red-500/10 transition-colors flex items-center gap-1.5"
                                onclick={handleDelete}
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >delete</span
                                >
                                Delete
                            </button>
                        {:else}
                            <button
                                class="px-3 py-1 rounded border border-border-dark text-[10px] font-bold uppercase tracking-widest text-text-muted hover:text-text-main transition-colors"
                                onclick={toggleEdit}
                            >
                                Cancel
                            </button>
                            <button
                                class="btn-primary py-1 px-3 text-[10px] font-bold uppercase tracking-widest flex items-center gap-1.5 shadow-lg shadow-primary/20"
                                onclick={saveEdit}
                            >
                                <span class="material-symbols-outlined text-sm"
                                    >save</span
                                >
                                Save
                            </button>
                        {/if}
                        <button class="offcanvas-close" onclick={closeDetails}>
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Tab Navigation -->
            <div
                class="px-6 border-b border-border-dark/50 bg-surface-dark flex items-center gap-6"
            >
                <button
                    class="py-3 text-[10px] font-bold uppercase tracking-[0.2em] border-b-2 transition-all {activeTab ===
                    'details'
                        ? 'text-primary border-primary'
                        : 'text-text-muted border-transparent hover:text-text-secondary'}"
                    onclick={() => (activeTab = "details")}
                >
                    Details
                </button>
                <button
                    class="py-3 text-[10px] font-bold uppercase tracking-[0.2em] border-b-2 transition-all {activeTab ===
                    'works'
                        ? 'text-primary border-primary'
                        : 'text-text-muted border-transparent hover:text-text-secondary'}"
                    onclick={() => (activeTab = "works")}
                >
                    Works
                </button>
                <button
                    class="py-3 text-[10px] font-bold uppercase tracking-[0.2em] border-b-2 transition-all {activeTab ===
                    'recordings'
                        ? 'text-primary border-primary'
                        : 'text-text-muted border-transparent hover:text-text-secondary'}"
                    onclick={() => (activeTab = "recordings")}
                >
                    Recordings
                </button>
            </div>

            <div class="flex-1 overflow-y-auto">
                {#if activeTab === "details"}
                    <div
                        class="p-8 flex flex-col items-center border-b border-border-dark/50 bg-gradient-to-b from-surface-darker to-surface-dark"
                    >
                        <div
                            class="size-20 rounded-full bg-surface-dark flex items-center justify-center text-text-muted shadow-xl border border-border-dark"
                        >
                            <span class="material-symbols-outlined text-3xl"
                                >{selectedHolder.avatar}</span
                            >
                        </div>
                        <div class="mt-4 text-center">
                            {#if isEditing}
                                <input
                                    id="edit-name"
                                    type="text"
                                    class="bg-surface-dark border border-border-dark rounded px-3 py-1 text-lg font-bold text-text-main text-center focus:border-primary/50 outline-none w-full max-w-xs"
                                    bind:value={editingHolder.name}
                                />
                                <div class="mt-2 flex justify-center">
                                    <select
                                        class="bg-surface-dark border border-border-dark rounded px-2 py-0.5 text-[10px] font-bold text-primary uppercase appearance-none text-center cursor-pointer"
                                        bind:value={editingHolder.type}
                                    >
                                        {#each types.filter((t) => t !== "All") as t}
                                            <option value={t}>{t}</option>
                                        {/each}
                                    </select>
                                </div>
                            {:else}
                                <h3
                                    class="text-xl font-bold text-text-main tracking-tight"
                                >
                                    {selectedHolder.name}
                                </h3>
                                <p
                                    class="text-primary font-bold text-[10px] tracking-widest uppercase mt-1"
                                >
                                    {selectedHolder.type}
                                </p>
                            {/if}
                        </div>
                    </div>

                    <div class="p-8 space-y-8">
                        <div class="grid grid-cols-2 gap-8">
                            <div class="space-y-1.5">
                                <p
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                                >
                                    IPI Number
                                </p>
                                {#if isEditing}
                                    <input
                                        id="edit-ipi"
                                        type="text"
                                        class="w-full bg-surface-darker border border-border-dark rounded px-3 py-1.5 text-xs text-text-main font-mono focus:border-primary/50 outline-none"
                                        bind:value={editingHolder.ipi}
                                    />
                                {:else}
                                    <p
                                        class="text-sm font-mono text-text-main font-bold tracking-tighter"
                                    >
                                        {selectedHolder.ipi}
                                    </p>
                                {/if}
                            </div>
                            <div class="space-y-1.5">
                                <p
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-muted"
                                >
                                    Status
                                </p>
                                {#if isEditing}
                                    <select
                                        id="edit-status"
                                        class="w-full bg-surface-darker border border-border-dark rounded px-3 py-1.5 text-xs text-text-main focus:border-primary/50 outline-none cursor-pointer"
                                        bind:value={editingHolder.status}
                                    >
                                        {#each statuses.filter((s) => s !== "All") as s}
                                            <option value={s}>{s}</option>
                                        {/each}
                                    </select>
                                {:else}
                                    <span
                                        class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-widest {selectedHolder.status ===
                                        'Active'
                                            ? 'bg-emerald-500/10 text-emerald-400'
                                            : 'bg-amber-500/10 text-amber-400'}"
                                    >
                                        {selectedHolder.status}
                                    </span>
                                {/if}
                            </div>
                        </div>

                        <div
                            class="space-y-4 pt-8 border-t border-border-dark/50"
                        >
                            <h4
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary"
                            >
                                Contact Registry
                            </h4>
                            <div class="space-y-4">
                                <div class="space-y-1.5">
                                    <label
                                        for="edit-email"
                                        class="text-[9px] font-bold text-text-muted uppercase tracking-widest ml-1"
                                        >Professional Email</label
                                    >
                                    {#if isEditing}
                                        <input
                                            id="edit-email"
                                            type="email"
                                            class="w-full bg-surface-darker border border-border-dark rounded px-3 py-1.5 text-xs text-text-main focus:border-primary/50 outline-none"
                                            bind:value={editingHolder.email}
                                        />
                                    {:else}
                                        <div class="flex items-center gap-3">
                                            <span
                                                class="material-symbols-outlined text-text-muted text-sm"
                                                >mail</span
                                            >
                                            <span
                                                class="text-sm text-text-main font-medium"
                                                >{selectedHolder.email ||
                                                    "N/A"}</span
                                            >
                                        </div>
                                    {/if}
                                </div>

                                <div class="grid grid-cols-2 gap-6">
                                    <div class="space-y-1.5">
                                        <label
                                            for="edit-phone"
                                            class="text-[9px] font-bold text-text-muted uppercase tracking-widest ml-1"
                                            >Phone Number</label
                                        >
                                        {#if isEditing}
                                            <input
                                                id="edit-phone"
                                                type="text"
                                                class="w-full bg-surface-darker border border-border-dark rounded px-3 py-1.5 text-xs text-text-main focus:border-primary/50 outline-none"
                                                bind:value={editingHolder.phone}
                                            />
                                        {:else}
                                            <div
                                                class="flex items-center gap-3"
                                            >
                                                <span
                                                    class="material-symbols-outlined text-text-muted text-sm"
                                                    >call</span
                                                >
                                                <span
                                                    class="text-sm text-text-main font-medium"
                                                    >{selectedHolder.phone ||
                                                        "N/A"}</span
                                                >
                                            </div>
                                        {/if}
                                    </div>
                                    <div class="space-y-1.5">
                                        <label
                                            for="edit-country"
                                            class="text-[9px] font-bold text-text-muted uppercase tracking-widest ml-1"
                                            >Territory / Country</label
                                        >
                                        {#if isEditing}
                                            <select
                                                id="edit-country"
                                                class="w-full bg-surface-darker border border-border-dark rounded px-3 py-1.5 text-xs text-text-main focus:border-primary/50 outline-none cursor-pointer"
                                                bind:value={
                                                    editingHolder.country
                                                }
                                            >
                                                {#each countries as c}
                                                    <option value={c}
                                                        >{c}</option
                                                    >
                                                {/each}
                                            </select>
                                        {:else}
                                            <div
                                                class="flex items-center gap-3"
                                            >
                                                <span
                                                    class="material-symbols-outlined text-text-muted text-sm"
                                                    >public</span
                                                >
                                                <span
                                                    class="text-sm text-text-main font-medium"
                                                    >{selectedHolder.country ||
                                                        "N/A"}</span
                                                >
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {:else if activeTab === "works"}
                    <div class="p-6">
                        <table class="table-enterprise w-full">
                            <thead>
                                <tr class="bg-surface-darker/50">
                                    <th class="py-2 px-4 text-[9px]">Title</th>
                                    <th class="py-2 px-4 text-[9px]">Role</th>
                                    <th
                                        class="py-2 px-4 text-[9px] text-right w-20"
                                        >Share %</th
                                    >
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border-dark/30">
                                {#each mockWorks as work}
                                    <tr
                                        class="hover:bg-primary/5 transition-colors"
                                    >
                                        <td
                                            class="py-3 px-4 text-xs font-bold text-text-main"
                                        >
                                            {work.title}
                                        </td>
                                        <td
                                            class="py-3 px-4 text-[10px] font-bold uppercase text-text-secondary tracking-widest"
                                        >
                                            {work.role}
                                        </td>
                                        <td
                                            class="py-3 px-4 text-xs font-mono text-primary text-right font-bold"
                                        >
                                            {work.share}%
                                        </td>
                                    </tr>
                                {/each}
                            </tbody>
                        </table>
                    </div>
                {:else if activeTab === "recordings"}
                    <div class="p-6">
                        <table class="table-enterprise w-full">
                            <thead>
                                <tr class="bg-surface-darker/50">
                                    <th class="py-2 px-4 text-[9px]"
                                        >Title / ISRC</th
                                    >
                                    <th class="py-2 px-4 text-[9px]">Role</th>
                                    <th
                                        class="py-2 px-4 text-[9px] text-right w-20"
                                        >Share %</th
                                    >
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border-dark/30">
                                {#each mockRecordings as rec}
                                    <tr
                                        class="hover:bg-primary/5 transition-colors"
                                    >
                                        <td class="py-3 px-4">
                                            <div
                                                class="text-xs font-bold text-text-main"
                                            >
                                                {rec.title}
                                            </div>
                                            <div
                                                class="text-[9px] font-mono text-text-muted mt-0.5 tracking-tighter"
                                            >
                                                {rec.isrc}
                                            </div>
                                        </td>
                                        <td
                                            class="py-3 px-4 text-[10px] font-bold uppercase text-text-secondary tracking-widest leading-none"
                                        >
                                            {rec.role}
                                        </td>
                                        <td
                                            class="py-3 px-4 text-xs font-mono text-primary text-right font-bold"
                                        >
                                            {rec.share}%
                                        </td>
                                    </tr>
                                {/each}
                            </tbody>
                        </table>
                    </div>
                {/if}
            </div>
        </aside>
    {/if}

    <!-- Add Holder Offcanvas -->
    {#if isCreateOffcanvasOpen}
        <div
            class="offcanvas-backdrop"
            role="button"
            tabindex="0"
            aria-label="Close panel"
            onclick={() => (isCreateOffcanvasOpen = false)}
            onkeydown={(e) =>
                e.key === "Escape" && (isCreateOffcanvasOpen = false)}
        ></div>
        <aside
            class="offcanvas-panel offcanvas-panel-wide"
            transition:fly={{ x: 560, duration: 400, opacity: 1 }}
        >
            <div class="offcanvas-header">
                <div class="flex items-center gap-3">
                    <div class="offcanvas-header-icon">
                        <span class="material-symbols-outlined">person_add</span
                        >
                    </div>
                    <div>
                        <h2 class="offcanvas-title">Add Rights Holder</h2>
                        <p class="offcanvas-subtitle">
                            Register a new entity in the system.
                        </p>
                    </div>
                </div>
                <button
                    class="offcanvas-close"
                    onclick={() => (isCreateOffcanvasOpen = false)}
                >
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto p-6 space-y-8">
                <div class="space-y-4">
                    <div class="space-y-2">
                        <label
                            class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                            for="holder-name">Full Name / Entity Name</label
                        >
                        <input
                            id="holder-name"
                            type="text"
                            placeholder="e.g., Sauti Sol"
                            class="input w-full"
                            bind:value={newHolder.name}
                        />
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="ipi">IPI Number</label
                            >
                            <input
                                id="ipi"
                                type="text"
                                placeholder="000.00.00.00"
                                class="input w-full font-mono text-xs"
                                bind:value={newHolder.ipi}
                            />
                        </div>
                        <div class="space-y-2">
                            <label
                                class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                for="type">Primary Type</label
                            >
                            <select
                                id="type"
                                class="select w-full"
                                bind:value={newHolder.type}
                            >
                                {#each types.filter((t) => t !== "All") as t}
                                    <option value={t}>{t}</option>
                                {/each}
                            </select>
                        </div>
                    </div>

                    <div class="space-y-4 pt-4">
                        <h4
                            class="text-xs font-bold uppercase tracking-widest text-text-secondary"
                        >
                            Contact Information
                        </h4>
                        <div class="space-y-3">
                            <div class="space-y-2">
                                <label
                                    for="new-email"
                                    class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                    >Email Address</label
                                >
                                <input
                                    id="new-email"
                                    type="email"
                                    placeholder="email@example.com"
                                    class="input w-full"
                                    bind:value={newHolder.email}
                                />
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="space-y-2">
                                    <label
                                        for="new-phone"
                                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                        >Phone</label
                                    >
                                    <input
                                        id="new-phone"
                                        type="text"
                                        placeholder="+254"
                                        class="input w-full"
                                        bind:value={newHolder.phone}
                                    />
                                </div>
                                <div class="space-y-2">
                                    <label
                                        for="new-country"
                                        class="text-[10px] font-bold uppercase tracking-widest text-text-secondary ml-1"
                                        >Country</label
                                    >
                                    <select
                                        id="new-country"
                                        class="select w-full"
                                        bind:value={newHolder.country}
                                    >
                                        {#each countries as c}
                                            <option value={c}>{c}</option>
                                        {/each}
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div
                class="p-6 border-t border-border-dark bg-surface-darker/50 backdrop-blur-md"
            >
                <button
                    class="w-full btn btn-primary py-4 font-bold uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl shadow-primary/20"
                    disabled={!newHolder.name}
                    onclick={handleAddHolder}
                >
                    <span class="material-symbols-outlined">save</span>
                    Register Holder
                </button>
            </div>
        </aside>
    {/if}

    <!-- Delete Confirmation Modal -->
    <Modal
        bind:isOpen={isDeleteModalOpen}
        title="Delete Rights Holder"
        message="Are you sure you want to delete {selectedHolder?.name}? This action will permanently remove their profile and association records. This cannot be undone."
        confirmText="Delete Holder"
        type="danger"
        onConfirm={confirmDelete}
    />
</div>

<style>
    .table-row {
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .table-row:hover {
        background: rgba(255, 255, 255, 0.02);
    }
    .table-row-active {
        background: rgba(16, 185, 129, 0.05) !important;
    }
    .input {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        transition: all 0.2s;
    }
    .input:focus {
        outline: none;
        border-color: #10b981;
        box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.1);
    }
    .select {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 0.75rem 1rem;
        color: #0f172a;
        font-size: 0.875rem;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 1rem center;
        background-size: 1rem;
    }
</style>
