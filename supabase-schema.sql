-- 
-- MURATH MUSNI PORTFOLIO - SUPABASE SCHEMA
-- Run this ONCE in your Supabase project's SQL Editor
-- (Dashboard -> SQL Editor -> New query -> paste all -> Run)
-- 

-- Enable UUID generation
create extension if not exists "pgcrypto";

-- 
-- 1. SITE CONTENT (profile, skills, experience, education, awards)
-- One single row holds everything editable except projects/blog.
-- 
create table if not exists site_content (
  id int primary key default 1,
  profile jsonb not null default '{}'::jsonb,
  skills jsonb not null default '[]'::jsonb,
  experience jsonb not null default '[]'::jsonb,
  education jsonb not null default '[]'::jsonb,
  awards jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  constraint single_row check (id = 1)
);

insert into site_content (id) values (1) on conflict (id) do nothing;

-- 
-- 2. PROJECTS
-- 
create table if not exists projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null default 'Network Design',
  description text not null default '',
  tools text[] not null default '{}',
  status text not null default 'Draft' check (status in ('Published','Draft','Hidden')),
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- 
-- 3. BLOG POSTS (Medium-style)
-- 
create table if not exists blog_posts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  excerpt text not null default '',
  cover_image_url text,
  content_html text not null default '',
  status text not null default 'draft' check (status in ('draft','published')),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 
-- 4. CONTACT MESSAGES
-- 
create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  message text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

-- 
-- ROW LEVEL SECURITY
-- This is the REAL security layer. The anon key used on the
-- public site can only do what these policies allow - it can
-- never write to your content. Only a signed-in admin (an
-- authenticated Supabase Auth user) can write.
-- 

alter table site_content enable row level security;
alter table projects enable row level security;
alter table blog_posts enable row level security;
alter table messages enable row level security;

-- site_content: anyone can read, only logged-in admin can edit
create policy "public read site_content" on site_content
  for select using (true);
create policy "admin write site_content" on site_content
  for update using (auth.role() = 'authenticated');

-- projects: public sees only Published, admin sees/edits everything
create policy "public read published projects" on projects
  for select using (status = 'Published' or auth.role() = 'authenticated');
create policy "admin insert projects" on projects
  for insert with check (auth.role() = 'authenticated');
create policy "admin update projects" on projects
  for update using (auth.role() = 'authenticated');
create policy "admin delete projects" on projects
  for delete using (auth.role() = 'authenticated');

-- blog_posts: public sees only published, admin sees/edits everything
create policy "public read published posts" on blog_posts
  for select using (status = 'published' or auth.role() = 'authenticated');
create policy "admin insert posts" on blog_posts
  for insert with check (auth.role() = 'authenticated');
create policy "admin update posts" on blog_posts
  for update using (auth.role() = 'authenticated');
create policy "admin delete posts" on blog_posts
  for delete using (auth.role() = 'authenticated');

-- messages: anyone (site visitor) can submit a message, only admin can read/manage
create policy "anyone can send a message" on messages
  for insert with check (true);
create policy "admin read messages" on messages
  for select using (auth.role() = 'authenticated');
create policy "admin update messages" on messages
  for update using (auth.role() = 'authenticated');
create policy "admin delete messages" on messages
  for delete using (auth.role() = 'authenticated');

-- 
-- SEED DATA - your current portfolio content, so the site
-- isn't empty on first load. Edit all of this later from /admin.html
-- 

update site_content set
  profile = '{
    "full_name": "Murath Musni",
    "title": "IT Executive | Network Engineer | System Administrator",
    "photo_url": "",
    "tagline": "IT Executive & Network Engineer with 3+ years securing enterprise infrastructure. Specialised in FortiGate, Cisco, Active Directory & AWS across fast-paced multi-user environments.",
    "availability_tag": "Available for new opportunities  Qatar",
    "email": "murathmusni@gmail.com",
    "phone": "+974 77321821",
    "location": "Doha, Qatar",
    "linkedin": "linkedin.com/in/murathmusni",
    "summary": "Results-driven IT professional with 3+ years of hands-on experience across IT support, network engineering, and systems administration. Currently based in Qatar with a transferable visa and available for immediate joining.",
    "availability_status": "Available for immediate joining",
    "languages": "English (Professional)  Tamil (Native)  Malayalam (Intermediate)  Hindi (Basic)",
    "stats": [
      {"num": "150+", "label": "Users supported"},
      {"num": "3+", "label": "Years experience"},
      {"num": "5", "label": "Key projects"},
      {"num": "1st", "label": "Class honours"}
    ]
  }'::jsonb,
  skills = '[
    {"icon":"","color":"teal","title":"Networking","description":"Cisco routing & switching, VLANs, OSPF, LAN/WAN architecture and IPSec/SSL VPN deployments.","tags":["TCP/IP","802.1Q","OSPF","IPSec VPN","SSL VPN","NAT"]},
    {"icon":"","color":"blue","title":"Security","description":"FortiGate firewall policy management, network segmentation, ACLs and penetration testing with Kali Linux.","tags":["FortiGate","ACLs","Kali Linux","WPA3","Wireshark","Nmap"]},
    {"icon":"","color":"purple","title":"Systems Administration","description":"Active Directory, Microsoft 365, Windows Server - user provisioning, Group Policy and helpdesk SLA management.","tags":["Active Directory","M365","Win Server","Group Policy","SolarWinds"]},
    {"icon":"","color":"orange","title":"Cloud & Automation","description":"AWS VPC, Python Boto3 for security automation and Bash scripting to reduce repetitive operational overhead.","tags":["AWS VPC","Python","Boto3","Bash","Security Groups"]}
  ]'::jsonb,
  experience = '[
    {"role":"IT Executive","company":"Paramount Group  Doha, Qatar","date":"Dec 2025 - Present","bullets":["Deliver end-user IT support for 150+ users across multiple departments, consistently meeting SLA targets.","Administer Active Directory and Microsoft 365 - user provisioning, access control, licence management and Group Policy.","Deploy and maintain enterprise infrastructure: desktops, printers, switches and access points.","Implemented data backup and disaster recovery solutions, safeguarding business continuity.","Drive proactive monitoring and preventive maintenance, significantly reducing unplanned downtime."]},
    {"role":"Network & IT Support Engineer","company":"Port City BPO  Sri Lanka","date":"Jan 2024 - Nov 2025","bullets":["Provided L2/L3 technical support resolving complex issues across Windows OS, business apps and email systems.","Configured routers, managed switches and FortiGate firewalls; enforced security through NAT, ACLs and policy management.","Designed and deployed VLAN segmentation and inter-VLAN routing, improving performance and reducing broadcast congestion.","Established and maintained secure VPN connectivity for remote users and site-to-site links.","Produced comprehensive network documentation and topology diagrams, improving team efficiency and audit readiness."]}
  ]'::jsonb,
  education = '[
    {"title":"BEng (Hons) Computer Networking & Cloud Security","institution":"London Metropolitan University  2025","badge":"First Class Honours","status":"earned"},
    {"title":"Higher National Diploma in Network Engineering","institution":"Esoft Metro Campus (Pearson BTEC)  2024","badge":"Distinction  Gold Medal","status":"earned"},
    {"title":"CCNA - Cisco Certified Network Associate","institution":"Cisco  Expected 2026","badge":"In Progress","status":"progress"},
    {"title":"AWS Certified Cloud Practitioner","institution":"Amazon Web Services  Expected 2026","badge":"In Progress","status":"progress"}
  ]'::jsonb,
  awards = '[
    {"title":"1st Runner-Up - Cyber Security & Networking Hackathon","description":"Recognised for designing a secure network architecture and live vulnerability analysis  2023"},
    {"title":"Gold Medalist - Higher National Diploma","description":"Highest academic performance in the Network Engineering programme  2024"},
    {"title":"First Class Honours - BEng Computer Networking & Cloud Security","description":"Graduated with distinction across all modules  2025"}
  ]'::jsonb
where id = 1;

insert into projects (title, category, description, tools, status, sort_order) values
('Enterprise Campus Network', 'Network Design', 'Designed and simulated a scalable multi-department campus network using 802.1Q VLANs, OSPF routing and ACLs. Reduced broadcast domain size and enforced strict inter-VLAN communication policies.', '{"Cisco Packet Tracer","Wireshark","OSPF","VLANs"}', 'Published', 1),
('Hybrid Cloud Secure Connectivity', 'Cloud Security', 'Deployed an IPSec VPN tunnel between an on-premise FortiGate firewall and AWS VPC for fully encrypted hybrid connectivity. Automated AWS security group auditing using Python Boto3.', '{"AWS VPC","FortiGate","Python (Boto3)","IPSec"}', 'Published', 2),
('Wireless Network Pen Test Lab', 'Penetration Testing', 'Conducted controlled penetration testing against WPA2 networks using Aircrack-ng and Nmap. Produced a remediation report recommending WPA3 migration and network re-segmentation.', '{"Kali Linux","Aircrack-ng","Nmap","WPA3"}', 'Published', 3),
('WiFi Adapter Diagnostic Tool', 'Automation', 'Developed a Bash script to automate pre-engagement validation of wireless adapters - checking driver status, RFKill state, monitor mode and packet injection, generating PASS/FAIL outputs.', '{"Bash","iw","tcpdump"}', 'Published', 4),
('Voice-Controlled System Tool', 'AI & Automation', 'Built a Python voice assistant using SpeechRecognition to execute system-level administrative commands via natural language, reducing repetitive manual tasks for IT operators.', '{"Python","SpeechRecognition","System Admin"}', 'Published', 5)
on conflict do nothing;

-- Feature upgrades: run this block in Supabase SQL Editor for existing projects.
alter table projects add column if not exists featured boolean not null default false;
alter table projects add column if not exists cover_image_url text;
alter table blog_posts add column if not exists category text not null default 'General';
alter table blog_posts add column if not exists tags text[] not null default '{}';
create table if not exists page_views (
 id bigint generated always as identity primary key,
 page_path text not null,
 post_slug text,
 created_at timestamptz not null default now()
);
alter table page_views enable row level security;
create policy "admin read page views" on page_views for select using (auth.role() = 'authenticated');
create policy "public read recent page views" on page_views for select using (created_at > now() - interval '5 minutes');
create policy "public record page views" on page_views for insert with check (char_length(page_path) <= 120 and (post_slug is null or char_length(post_slug) <= 160));
