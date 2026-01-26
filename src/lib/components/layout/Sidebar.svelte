<script lang="ts">
	import { page } from "$app/stores";

	let user = $derived($page.data.user);
	let profile = $derived(user?.profile);

	interface NavItem {
		label: string;
		href: string;
		icon: string;
		children?: NavItem[];
	}

	const navigation: NavItem[] = [
		{ label: "Dashboard", href: "/dashboard", icon: "dashboard" },
		{
			label: "My Music",
			href: "/music",
			icon: "library_music",
			children: [
				{ label: "Songs", href: "/music/songs", icon: "music_note" },
				{ label: "Upload", href: "/music/upload", icon: "upload" },
				{ label: "Splits", href: "/music/splits", icon: "pie_chart" },
			],
		},
		{
			label: "Tracking",
			href: "/tracking",
			icon: "radio",
			children: [
				{
					label: "Play Log",
					href: "/tracking/plays",
					icon: "list_alt",
				},
				{
					label: "Disputes",
					href: "/tracking/disputes",
					icon: "gavel",
				},
				{ label: "Verify", href: "/tracking/verify", icon: "verified" },
			],
		},
		{
			label: "Royalties",
			href: "/royalties",
			icon: "payments",
			children: [
				{
					label: "Estimates",
					href: "/royalties/estimates",
					icon: "calculate",
				},
				{
					label: "Rates",
					href: "/royalties/rates",
					icon: "request_quote",
				},
				{
					label: "Reconcile",
					href: "/royalties/reconcile",
					icon: "compare_arrows",
				},
			],
		},
		{
			label: "Analytics",
			href: "/analytics",
			icon: "analytics",
			children: [
				{ label: "Overview", href: "/analytics", icon: "bar_chart" },
				{
					label: "Geographic",
					href: "/analytics/geographic",
					icon: "public",
				},
				{
					label: "Trends",
					href: "/analytics/trends",
					icon: "trending_up",
				},
				{
					label: "Intelligence",
					href: "/analytics/intelligence",
					icon: "psychology",
				},
			],
		},
		{
			label: "Settings",
			href: "/settings",
			icon: "settings",
			children: [
				{ label: "Profile", href: "/settings/profile", icon: "person" },
				{
					label: "Security",
					href: "/settings/security",
					icon: "shield",
				},
			],
		},
	];

	const bottomNav: NavItem[] = [
		{ label: "Help & Docs", href: "/help", icon: "help" },
	];

	function isActive(href: string): boolean {
		return (
			$page.url.pathname === href ||
			$page.url.pathname.startsWith(href + "/")
		);
	}

	let expandedSections = $state<Set<string>>(new Set());

	function toggleSection(label: string) {
		if (expandedSections.has(label)) {
			expandedSections.delete(label);
		} else {
			expandedSections.add(label);
		}
		expandedSections = new Set(expandedSections);
	}
</script>

<aside
	class="w-64 flex-shrink-0 border-r border-border-dark bg-surface-darker flex flex-col justify-between p-4 hidden md:flex"
>
	<div class="flex flex-col gap-6">
		<!-- Logo -->
		<div class="flex items-center gap-3 px-2">
			<div
				class="size-10 rounded-full bg-gradient-to-tr from-primary to-emerald-600 flex items-center justify-center text-background-dark"
			>
				<span class="material-symbols-outlined icon-fill"
					>equalizer</span
				>
			</div>
			<div>
				<h1 class="font-bold text-lg tracking-tight">Spaza Airplay</h1>
				<p class="text-xs text-text-secondary">Artist Portal</p>
			</div>
		</div>

		<!-- Main Navigation -->
		<nav class="flex flex-col gap-1">
			{#each navigation as item}
				{#if item.children}
					<!-- Collapsible section -->
					<button
						class="nav-item w-full justify-between"
						class:nav-item-active={isActive(item.href)}
						onclick={() => toggleSection(item.label)}
					>
						<span class="flex items-center gap-3">
							<span class="material-symbols-outlined"
								>{item.icon}</span
							>
							<span class="text-sm font-medium">{item.label}</span
							>
						</span>
						<span
							class="material-symbols-outlined text-sm transition-transform"
							class:rotate-180={expandedSections.has(item.label)}
						>
							expand_more
						</span>
					</button>
					{#if expandedSections.has(item.label)}
						<div class="ml-6 flex flex-col gap-1 mt-1">
							{#each item.children as child}
								<a
									href={child.href}
									class="nav-item text-sm"
									class:nav-item-active={isActive(child.href)}
								>
									<span
										class="material-symbols-outlined text-lg"
										>{child.icon}</span
									>
									<span>{child.label}</span>
								</a>
							{/each}
						</div>
					{/if}
				{:else}
					<!-- Simple link -->
					<a
						href={item.href}
						class="nav-item"
						class:nav-item-active={isActive(item.href)}
					>
						<span class="material-symbols-outlined"
							>{item.icon}</span
						>
						<span class="text-sm font-medium">{item.label}</span>
					</a>
				{/if}
			{/each}
		</nav>
	</div>

	<!-- Bottom Navigation -->
	<div class="flex flex-col gap-1">
		{#each bottomNav as item}
			<a
				href={item.href}
				class="nav-item"
				class:nav-item-active={isActive(item.href)}
			>
				<span class="material-symbols-outlined">{item.icon}</span>
				<span class="text-sm font-medium">{item.label}</span>
			</a>
		{/each}

		<!-- User Profile -->
		<div class="flex items-center gap-3 mt-4 pt-4 border-t border-white/10">
			<div
				class="rounded-full size-10 border-2 border-primary/20 bg-surface-dark flex items-center justify-center overflow-hidden"
			>
				{#if profile?.avatar_url}
					<img
						src={profile.avatar_url}
						alt={profile.full_name}
						class="w-full h-full object-cover"
					/>
				{:else}
					<span class="material-symbols-outlined text-text-secondary"
						>person</span
					>
				{/if}
			</div>
			<div class="flex-1 min-w-0">
				<p class="text-sm font-bold truncate">
					{profile?.full_name || "Anonymous"}
				</p>
				<p class="text-xs text-text-secondary truncate">
					{profile?.plan
						? profile.plan.charAt(0).toUpperCase() +
							profile.plan.slice(1)
						: "Standard"} Plan
				</p>
			</div>
			<form action="/api/logout" method="POST">
				<button
					type="submit"
					class="p-2 text-text-secondary hover:text-red-500 transition-colors"
					title="Sign Out"
				>
					<span class="material-symbols-outlined text-[20px]"
						>logout</span
					>
				</button>
			</form>
		</div>
	</div>
</aside>
