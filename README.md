# Murath Musni — Portfolio + Blog + Admin (100% free)

This is your portfolio, wired to a real database so anything you change in
`admin.html` shows up live for every visitor — plus a Medium-style blog and
real, secure login (no password anywhere in the code).

**Stack, all free tier:** Supabase (database + login + image storage) + GitHub Pages (hosting).

---

## 1. Create your free Supabase project (5 min)

1. Go to **supabase.com** → sign up (free, no card needed) → **New project**.
2. Pick any name/region, set a strong database password (you won't need this day-to-day), wait ~2 min for it to spin up.
3. In the left sidebar go to **SQL Editor** → **New query**.
4. Open `supabase-schema.sql` from this folder, copy all of it, paste it in, click **Run**.
   This creates your tables, locks them down with real security rules, and loads your current résumé content so the site isn't empty.
5. Go to **Storage** (left sidebar) → **New bucket** → name it `media` → toggle **Public bucket** ON → Create.
   (This is where blog cover images and any uploaded photos live.)

## 2. Create your admin login (2 min)

This is your **real password** — it lives only here, hashed, never in any file.

1. In Supabase: **Authentication** → **Users** → **Add user** → **Create new user**.
2. Enter your email and a strong password. Leave "Auto Confirm User" checked.
3. That's it — this email + password is what you'll use to sign in at `admin.html`.

## 3. Connect the site to your project (2 min)

1. In Supabase: **Project Settings** → **API**.
2. Copy the **Project URL** and the **anon public** key.
3. Open `config.js` in this folder and paste them in:
   ```js
   const SUPABASE_URL = "https://xxxxxxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGciOi...";
   ```
   The anon key is meant to be public — it can't bypass the security rules from step 1.

## 4. Put it on the internet for free with GitHub Pages

1. Create a new GitHub repository (public or private both work with Pages).
2. Upload all the files in this folder (`index.html`, `blog.html`, `post.html`,
   `admin.html`, `config.js`) to the repo — drag-and-drop on github.com works fine.
3. Repo → **Settings** → **Pages** → under "Build and deployment", Source = **Deploy from a branch**, Branch = `main` / `(root)` → **Save**.
4. After ~1 minute your site is live at `https://yourusername.github.io/your-repo-name/`.
5. Your admin panel is at `.../admin.html` — bookmark it, it's not linked anywhere obvious except a small "Sign in" link in the site footer.

## 5. Using it day to day

- **Edit anything** (profile, skills, experience, education, projects) at `/admin.html` → click **Save** → it's instantly live on the public site for everyone. No redeploy needed.
- **Write a blog post**: Admin → Blog tab → write with the rich text editor (bold, images, headings, links, quotes) → **Save draft** while working, **Publish** when ready. Published posts appear on `/blog.html` immediately, newest first.
- **Messages**: anything submitted through your Contact form appears under Admin → Messages.
- **Change your password**: Admin → Security tab, or Supabase Dashboard → Authentication → Users.

## What "top quality security" actually means here

- Your password is checked by Supabase's servers, hashed, never shipped in any file — unlike the version you had before, where the password was literally readable in the page's source code.
- The public pages only ever have **read** access to published content. Every write (save, publish, delete) is blocked by database-level rules unless you're signed in — this is enforced by the database itself, not just hidden by JavaScript.
- Nothing here can be made "unhackable" — no website can — but this setup follows the same real-auth pattern used by production apps, which is a categorical step up from a hardcoded password.

## Costs

Everything here stays free at portfolio-blog scale: Supabase free tier (500MB database, 1GB file storage, 50k monthly active users) and GitHub Pages (unlimited public sites) comfortably cover a personal site. You'd only ever need to pay if this got very high traffic — nothing to set up or worry about now.

## Files in this folder

| File | Purpose |
|---|---|
| `index.html` | Your public portfolio (reads live data from Supabase) |
| `blog.html` | Blog post list |
| `post.html` | Single blog post reader |
| `admin.html` | Password-protected admin — edit everything, write posts |
| `config.js` | Your Supabase connection details (steps 1–3 above) |
| `supabase-schema.sql` | Run once in Supabase to set up the database |
