<script lang="ts">
    import Sidebar from "$lib/components/layout/Sidebar.svelte";
    import Header from "$lib/components/layout/Header.svelte";

    let { children } = $props();
</script>

<div class="flex h-screen overflow-hidden bg-background-dark">
    <!-- Sidebar -->
    <Sidebar />

    <!-- Main Content Area -->
    <main class="flex-1 flex flex-col h-full overflow-hidden">
        <!-- Header -->
        <!-- <Header /> -->

        <!-- Page Content -->
        <div class="flex-1 overflow-y-auto overflow-x-hidden">
            {@render children()}
        </div>
    </main>
</div>
