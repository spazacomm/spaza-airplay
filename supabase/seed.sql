-- MUSIC ROYALTY PLATFORM SEED DATA
-- Focus: East Africa (Kenya, Uganda, Tanzania, Rwanda, DRC, Ethiopia, Burundi)
-- Data generated for testing purposes.

BEGIN;

-- 1. ORGANIZATIONS
INSERT INTO organizations (id, name, type, country, metadata) VALUES
(uuid_generate_v4(), 'Sauti Sol Entertainment', 'Label', 'Kenya', '{"founded": 2012, "headquarters": "Nairobi"}'),
(uuid_generate_v4(), 'WCB Wasafi', 'Label', 'Tanzania', '{"founded": 2016, "headquarters": "Dar es Salaam"}'),
(uuid_generate_v4(), 'Swangz Avenue', 'Label', 'Uganda', '{"founded": 2008, "headquarters": "Kampala"}'),
(uuid_generate_v4(), 'Kina Music', 'Label', 'Rwanda', '{"founded": 2009, "headquarters": "Kigali"}'),
(uuid_generate_v4(), 'Coke Studio Africa', 'Aggregator', 'Kenya', '{"type": "Pan-African Production"}'),
(uuid_generate_v4(), 'Nation Media Group', 'Broadcaster', 'Kenya', '{"stations": ["NTv", "QFM", "Nation FM"]}'),
(uuid_generate_v4(), 'Clouds Media Group', 'Broadcaster', 'Tanzania', '{"stations": ["Clouds FM", "Clouds TV"]}'),
(uuid_generate_v4(), 'Vision Group', 'Broadcaster', 'Uganda', '{"stations": ["Bukedde TV", "XFM"]}');

-- 2. ROYALTY SOCIETIES (CMOs)
INSERT INTO royalty_societies (id, name, full_name, country, currency) VALUES
(uuid_generate_v4(), 'MCSK', 'Music Copyright Society of Kenya', 'Kenya', 'KES'),
(uuid_generate_v4(), 'KAMP', 'Kenya Association of Music Producers', 'Kenya', 'KES'),
(uuid_generate_v4(), 'PRISK', 'Performers Rights Society of Kenya', 'Kenya', 'KES'),
(uuid_generate_v4(), 'UPRS', 'Uganda Performing Right Society', 'Uganda', 'UGX'),
(uuid_generate_v4(), 'COSOTA', 'Copyright Society of Tanzania', 'Tanzania', 'TZS'),
(uuid_generate_v4(), 'RSA', 'Rwanda Society of Authors', 'Rwanda', 'RWF'),
(uuid_generate_v4(), 'SOCODA', 'Société Congolaise des Droits d''Auteurs', 'DRC', 'USD'),
(uuid_generate_v4(), 'OTHER', 'Ethiopian Music Copyright & Neighbouring Rights CMO', 'Ethiopia', 'ETB');

-- 3. RIGHTS HOLDERS (Artists, Producers, Publishers)
-- We store IDs to link later
DO $$
DECLARE
    kh_id UUID;
    vinka_id UUID;
    diamond_id UUID;
    bruce_id UUID;
    fally_id UUID;
    teddy_id UUID;
BEGIN
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Khaligraph Jones', 'IPI-001-KE', 'performer') RETURNING id INTO kh_id;
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Vinka', 'IPI-002-UG', 'performer') RETURNING id INTO vinka_id;
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Diamond Platnumz', 'IPI-003-TZ', 'performer') RETURNING id INTO diamond_id;
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Bruce Melodie', 'IPI-004-RW', 'performer') RETURNING id INTO bruce_id;
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Fally Ipupa', 'IPI-005-CD', 'performer') RETURNING id INTO fally_id;
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Teddy Afro', 'IPI-006-ET', 'performer') RETURNING id INTO teddy_id;
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Magic Enga', 'IPI-PROD-001', 'producer');
    INSERT INTO rights_holders (name, ipi_number, type) VALUES ('Sol Generation Publishing', 'IPI-PUB-001', 'publisher');
END $$;

-- 4. WORKS & RECORDINGS
-- Creating representative hits from the region
DO $$
DECLARE
    w_mazishi UUID;
    w_tetema UUID;
    w_malaika UUID;
BEGIN
    -- Kenya Work
    INSERT INTO works (title, iswc, contributors, metadata) 
    VALUES ('Mazishi', 'T-001.000.001-C', '[{"name": "Khaligraph Jones", "role": "Composer"}]', '{"genre": "Hip Hop", "bpm": 95}')
    RETURNING id INTO w_mazishi;
    
    INSERT INTO recordings (work_id, title, isrc, duration_seconds, release_date, fingerprint_id)
    VALUES (w_mazishi, 'Mazishi (Original Mix)', 'KE-A12-20-00001', 210, '2020-05-15', 'FP-KH-MAZ-001');

    -- Tanzania Work
    INSERT INTO works (title, iswc, contributors, metadata) 
    VALUES ('Tetema', 'T-002.000.001-C', '[{"name": "Diamond Platnumz", "role": "Composer"}, {"name": "Rayvanny", "role": "Composer"}]', '{"genre": "Bongo Flava", "bpm": 105}')
    RETURNING id INTO w_tetema;
    
    INSERT INTO recordings (work_id, title, isrc, duration_seconds, release_date, fingerprint_id)
    VALUES (w_tetema, 'Tetema (Club Edit)', 'TZ-WCB-19-00042', 195, '2019-02-10', 'FP-DP-TET-002');

    -- Rwanda Work
    INSERT INTO works (title, iswc, contributors, metadata) 
    VALUES ('Katerina', 'T-003.000.001-C', '[{"name": "Bruce Melodie", "role": "Composer"}]', '{"genre": "Afrobeat", "bpm": 100}')
    RETURNING id INTO w_malaika;
    
    INSERT INTO recordings (work_id, title, isrc, duration_seconds, release_date, fingerprint_id)
    VALUES (w_malaika, 'Katerina', 'RW-KINA-19-00001', 205, '2019-11-20', 'FP-BM-KAT-003');

    -- Uganda Work
    INSERT INTO works (title, iswc, contributors, metadata) 
    VALUES ('Malaika', 'T-004.000.001-C', '[{"name": "Vinka", "role": "Composer"}]', '{"genre": "Dancehall", "bpm": 110}')
    RETURNING id INTO w_malaika;

    INSERT INTO recordings (work_id, title, isrc, duration_seconds, release_date, fingerprint_id)
    VALUES (w_malaika, 'Malaika', 'UG-SWNG-20-00001', 188, '2020-01-10', 'FP-VK-MAL-004');

    -- DRC Work
    INSERT INTO works (title, iswc, contributors, metadata) 
    VALUES ('Inama', 'T-005.000.001-C', '[{"name": "Fally Ipupa", "role": "Composer"}]', '{"genre": "Rumba", "bpm": 90}')
    RETURNING id INTO w_malaika;

    INSERT INTO recordings (work_id, title, isrc, duration_seconds, release_date, fingerprint_id)
    VALUES (w_malaika, 'Inama', 'CD-SOC-19-00001', 245, '2019-06-05', 'FP-FI-INA-005');
END $$;

-- 4b. RIGHTS SPLITS
DO $$
DECLARE
    kh_id UUID;
    dp_id UUID;
    vk_id UUID;
    w_mazishi UUID;
    w_tetema UUID;
    r_mazishi UUID;
    r_tetema UUID;
BEGIN
    SELECT id INTO kh_id FROM rights_holders WHERE name = 'Khaligraph Jones';
    SELECT id INTO dp_id FROM rights_holders WHERE name = 'Diamond Platnumz';
    SELECT id INTO vk_id FROM rights_holders WHERE name = 'Vinka';
    
    SELECT id INTO w_mazishi FROM works WHERE title = 'Mazishi';
    SELECT id INTO w_tetema FROM works WHERE title = 'Tetema';
    
    SELECT id INTO r_mazishi FROM recordings WHERE title = 'Mazishi (Original Mix)';
    SELECT id INTO r_tetema FROM recordings WHERE title = 'Tetema (Club Edit)';

    -- Work Rights (Publishing)
    INSERT INTO work_rights (work_id, rights_holder_id, role, share_percentage) VALUES
    (w_mazishi, kh_id, 'composer', 100.00),
    (w_tetema, dp_id, 'composer', 50.00);

    -- Recording Rights (Master)
    INSERT INTO recording_rights (recording_id, rights_holder_id, role, share_percentage) VALUES
    (r_mazishi, kh_id, 'performer', 80.00),
    (r_tetema, dp_id, 'performer', 70.00);
END $$;

-- 5. SOURCES (Monitoring Stations)
INSERT INTO sources (name, type, ingestion_type, country, region, city, status, stream_url) VALUES
('Citizen FM', 'commercial_radio', 'web_stream', 'Kenya', 'Nairobi', 'Nairobi', 'active', 'http://stream.citizen.co.ke/live'),
('Classic 105', 'commercial_radio', 'web_stream', 'Kenya', 'Nairobi', 'Nairobi', 'active', 'http://radio.classic105.com/stream'),
('Clouds FM', 'commercial_radio', 'web_stream', 'Tanzania', 'Pwani', 'Dar es Salaam', 'active', 'http://clouds.fm/live'),
('Sanyu FM', 'commercial_radio', 'web_stream', 'Uganda', 'Central', 'Kampala', 'active', 'http://sanyufm.co.ug/live'),
('Radio Rwanda', 'public_broadcaster', 'web_stream', 'Rwanda', 'Kigali', 'Kigali', 'active', 'http://rba.co.rw/radio-rwanda'),
('Radio Okapi', 'public_broadcaster', 'web_stream', 'DRC', 'Kinshasa', 'Kinshasa', 'active', 'http://radiookapi.net/live'),
('Sheger FM', 'commercial_radio', 'web_stream', 'Ethiopia', 'Addis Ababa', 'Addis Ababa', 'active', 'http://shegerfm.et/live'),
('Radio Isanganiro', 'community_radio', 'web_stream', 'Burundi', 'Bujumbura', 'Bujumbura', 'active', 'http://isanganiro.org/live');

-- 6. RATE TABLES
INSERT INTO rate_tables (society_id, source_type, calculation_method, rate_amount, revenue_percentage, effective_date)
SELECT 
    id, 
    'commercial_radio'::source_type, 
    'percentage_revenue'::calculation_method, 
    NULL, 
    4.00, 
    '2024-01-01'
FROM royalty_societies WHERE name = 'MCSK';

INSERT INTO rate_tables (society_id, source_type, calculation_method, rate_amount, revenue_percentage, effective_date)
SELECT 
    id, 
    'commercial_radio'::source_type, 
    'per_play'::calculation_method, 
    0.20, 
    NULL, 
    '2025-07-01'
FROM royalty_societies WHERE name = 'OTHER'; -- Ethiopia

-- 7. PLAY LOGS (Generating ~500 rows using a loop)
DO $$
DECLARE
    src_ids UUID[];
    rec_ids UUID[];
    i INT;
    rand_src UUID;
    rand_rec UUID;
    start_time TIMESTAMPTZ;
BEGIN
    SELECT array_agg(id) INTO src_ids FROM sources;
    SELECT array_agg(id) INTO rec_ids FROM recordings;
    
    FOR i IN 1..500 LOOP
        rand_src := src_ids[floor(random() * array_length(src_ids, 1) + 1)];
        rand_rec := rec_ids[floor(random() * array_length(rec_ids, 1) + 1)];
        start_time := NOW() - (random() * interval '30 days');
        
        INSERT INTO play_logs (source_id, recording_id, timestamp_start, duration_played_seconds, confidence_score)
        VALUES (
            rand_src,
            rand_rec,
            start_time,
            floor(random() * 240 + 30), -- 30s to 270s
            random() * 0.4 + 0.6 -- 0.6 to 1.0 confidence
        );
    END LOOP;
END $$;

COMMIT;
