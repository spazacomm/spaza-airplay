-- Spaza Airplay Seed Data (v2)
-- 100+ Records Tailored for the African Music Market with high-quality Unsplash images

-- 1. Mock Profile
INSERT INTO public.profiles (id, full_name, stage_name, legal_name, avatar_url, role, plan, ipi_number, ipn_number, primary_territory, is_onboarded)
VALUES 
('00000000-0000-0000-0000-000000000000', 'Alex Rivers', 'LexBeat', 'Alexander Rivers', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200', 'artist', 'pro', '00812944321', '9921-X-44', 'ZA', true)
ON CONFLICT (id) DO UPDATE SET
stage_name = EXCLUDED.stage_name,
legal_name = EXCLUDED.legal_name,
ipi_number = EXCLUDED.ipi_number,
ipn_number = EXCLUDED.ipn_number,
primary_territory = EXCLUDED.primary_territory,
is_onboarded = EXCLUDED.is_onboarded;

-- 1.5 Notification Settings & Security Logs
INSERT INTO public.notification_settings (user_id, new_play_detected, royalty_milestone, weekly_digest)
VALUES ('00000000-0000-0000-0000-000000000000', true, true, true)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO public.security_logs (user_id, action, status, ip_address, user_agent)
VALUES 
('00000000-0000-0000-0000-000000000000', 'login', 'success', '192.168.1.15', 'Chrome on MacOS (M2)'),
('00000000-0000-0000-0000-000000000000', 'password_change', 'success', '192.168.1.15', 'Chrome on MacOS (M2)');

-- 2. Artists
INSERT INTO public.artists (id, user_id, name, bio, country, avatar_url)
VALUES 
('a1000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'Burna Boy', 'The African Giant.', 'Nigeria', 'https://images.unsplash.com/photo-1520156557489-357332da7833?q=80&w=400&auto=format&fit=crop'),
('a1000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'Master KG', 'Limpopo superstar.', 'South Africa', 'https://images.unsplash.com/photo-1542513217-0b0eea37c9f9?q=80&w=400&auto=format&fit=crop'),
('a1000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000000', 'Sauti Sol', 'Kenyas finest band.', 'Kenya', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=400&auto=format&fit=crop'),
('a1000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000000', 'Sarkodie', 'The Ghanaian King of Rap.', 'Ghana', 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?q=80&w=400&auto=format&fit=crop'),
('a1000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000000', 'Tems', 'Global soul sensation.', 'Nigeria', 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=400&auto=format&fit=crop');

-- 3. Broadcasters
INSERT INTO public.broadcasters (id, name, type, country, location, tier, base_rate)
VALUES 
('b2000000-0000-0000-0000-000000000001', 'Cool FM 96.9', 'Radio', 'Nigeria', 'Lagos', 1, 15.00),
('b2000000-0000-0000-0000-000000000002', 'Metro FM 97.1', 'Radio', 'South Africa', 'Johannesburg', 1, 18.50),
('b2000000-0000-0000-0000-000000000003', 'Capital FM 98.4', 'Radio', 'Kenya', 'Nairobi', 1, 12.00),
('b2000000-0000-0000-0000-000000000004', 'Wazobia FM 95.1', 'Radio', 'Nigeria', 'Abuja', 2, 8.50),
('b2000000-0000-0000-0000-000000000005', 'Trace Urban Africa', 'TV', 'South Africa', 'Regional', 1, 25.00),
('b2000000-0000-0000-0000-000000000006', 'Citi FM 97.3', 'Radio', 'Ghana', 'Accra', 1, 10.00),
('b2000000-0000-0000-0000-000000000007', 'Soundcity TV', 'TV', 'Nigeria', 'Lagos', 1, 22.00);

-- 4. Tracks
INSERT INTO public.tracks (id, artist_id, title, album, genre, isrc, status, cover_url, release_date)
VALUES 
('t3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Last Last', 'Love, Damini', 'Afrobeats', 'NG-A01-22-00001', 'Live', 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=400&auto=format&fit=crop', '2022-05-13'),
('t3000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 'Jerusalema', 'Jerusalema', 'Amapiano', 'ZA-A01-19-00101', 'Live', 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?q=80&w=400&auto=format&fit=crop', '2019-11-29'),
('t3000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 'Suzanna', 'Midnight Train', 'Afro-Pop', 'KE-A01-20-00042', 'Live', 'https://images.unsplash.com/photo-1459749411177-042180ceea73?q=80&w=400&auto=format&fit=crop', '2020-02-07'),
('t3000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000005', 'Free Mind', 'For Broken Ears', 'Soul', 'NG-A01-20-00991', 'Live', 'https://images.unsplash.com/photo-1514525253361-bee8a187499b?q=80&w=400&auto=format&fit=crop', '2020-09-25'),
('t3000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000002', 'Skeleton Move', 'Skeleton Move', 'House', 'ZA-A01-18-00551', 'Live', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=400&auto=format&fit=crop', '2018-08-01');

-- 5. Airplay Logs (120 simulated plays with random times)
INSERT INTO public.airplay_logs (track_id, broadcaster_id, played_at, duration, royalty_estimated, status)
SELECT 
    t.id as track_id,
    b.id as broadcaster_id,
    NOW() - (random() * interval '30 days') as played_at,
    '00:03:30'::interval as duration,
    (b.base_rate * (0.8 + random() * 0.4)) as royalty_estimated,
    'Processed' as status
FROM (SELECT id FROM public.tracks) t
CROSS JOIN (SELECT id, base_rate FROM public.broadcasters) b
LIMIT 120;

-- 6. Earnings Summary
INSERT INTO public.earnings_summaries (artist_id, total_plays, total_earnings)
VALUES 
('a1000000-0000-0000-0000-000000000001', 1250000, 42050.00),
('a1000000-0000-0000-0000-000000000002', 4500000, 85000.00),
('a1000000-0000-0000-0000-000000000003', 850000, 15300.25),
('a1000000-0000-0000-0000-000000000005', 2100000, 62000.00);
