<script lang="ts">
	// Props
	let { title = "" }: { title?: string } = $props();
</script>

<header
	class="h-16 border-b border-border-dark flex items-center justify-between px-6 bg-white/95 backdrop-blur z-10"
>
	<!-- Mobile Menu Trigger -->
	<div class="md:hidden flex items-center gap-4 mr-4">
		<button class="text-text-primary">
			<span class="material-symbols-outlined">menu</span>
		</button>
		<img
			src="/logo-icon.png"
			alt="Spaza Airplay"
			class="size-8 object-contain"
		/>
	</div>

	<!-- Search -->
	<div class="flex-1 max-w-md hidden md:block">
		<div class="relative group">
			<span
				class="material-symbols-outlined absolute left-3 top-2.5 text-text-muted group-focus-within:text-primary transition-colors pointer-events-none"
			>
				search
			</span>
			<input
				type="text"
				class="w-full bg-background-dark border border-border-dark rounded-md py-2 px-10 text-sm text-text-primary placeholder:text-text-muted/60 focus:ring-1 focus:ring-primary focus:border-primary transition-all shadow-saas-sm"
				placeholder="Search songs, albums, or ISRC..."
			/>
		</div>
	</div>

	<!-- Page Title (Mobile) -->
	{#if title}
		<h2 class="md:hidden text-lg font-bold">{title}</h2>
	{/if}

	<!-- Actions -->
</header>
