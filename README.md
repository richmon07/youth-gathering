# IRON Youth Fellowship site

Files: `index.html` (the whole site), `schema.sql` (database).

## Set up Supabase (free)
1. Create a project at supabase.com.
2. SQL Editor: paste `schema.sql` and run it.
3. Authentication > Sign In / Providers: turn ON "Allow anonymous sign-ins". Turn OFF "Allow new users to sign up" (email).
4. Authentication > Users > Add user: create the admin email and password. Only this person can read join requests and messages.
5. Project Settings > API: copy the Project URL and the anon public key into `CFG` at the top of the last `<script>` in `index.html`.
   (The anon key is meant to be public. Row Level Security in the SQL protects the data. Never use the service_role key.)

## Put it online (free)
Upload `index.html` to Netlify Drop, Vercel, Cloudflare Pages or GitHub Pages.

## Use
Visitors RSVP, post on the wall, send join requests and messages without logging in.
Admin: footer > Admin > sign in. The Admin inbox appears and the admin can delete wall posts.
Light/dark toggle is in the top bar. It remembers the choice and follows the device setting at first.
