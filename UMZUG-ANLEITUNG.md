# Umzug von IONOS zu Cloudflare Pages

**Ziel:** Hosting für `ftmanager.de` und `rwwertec.de` kostenlos bei Cloudflare, beide Domains bleiben bei IONOS.
**Stand:** 23.09.2026

---

## ⚠️ Vorher lesen: zwei Dinge, die schiefgehen können

**1. E-Mail.** An beiden Domains hängen IONOS-Postfächer (MX auf `mx00/mx01.ionos.de`).
Beim Nameserver-Wechsel müssen diese Einträge mitwandern, sonst kommt **keine Mail mehr an**.
Alle zu übernehmenden Einträge stehen unten in Schritt 3.

**2. IONOS-Tarif.** Bevor du kündigst oder herunterstufst: Prüfe, ob im gewünschten
Domain-Paket E-Mail-Postfächer enthalten sind. Reine Domain-Tarife haben oft keine.

---

## Schritt 1 — Cloudflare-Konto

1. Auf `dash.cloudflare.com` kostenlos registrieren.
2. "Add a site" → `ftmanager.de` → Plan **Free** wählen.
3. Cloudflare scannt die vorhandenen DNS-Einträge und übernimmt sie meist automatisch.
   **Trotzdem gegen die Liste in Schritt 3 prüfen.**
4. Dasselbe für `rwwertec.de`.

## Schritt 2 — Nameserver bei IONOS umstellen

Cloudflare nennt dir zwei Nameserver (Form: `xyz.ns.cloudflare.com`).

IONOS → Domains & SSL → Domain auswählen → **Nameserver** → "Eigene Nameserver verwenden"
→ die beiden Cloudflare-Nameserver eintragen.

Aktuell stehen dort die IONOS-Nameserver (`ns….ui-dns.com/.de/.org/.biz`).

Übernahme dauert meist unter einer Stunde, laut Spezifikation bis zu 24 Stunden.

## Schritt 3 — DNS-Einträge kontrollieren

Diese Einträge müssen **nach** dem Wechsel in Cloudflare vorhanden sein
(Werte am 23.09.2026 ausgelesen):

### ftmanager.de
| Typ | Name | Wert | Proxy |
|---|---|---|---|
| MX | @ | `mx00.ionos.de` (Prio 10) | DNS only |
| MX | @ | `mx01.ionos.de` (Prio 10) | DNS only |
| TXT | @ | `v=spf1 include:_spf-eu.ionos.com ~all` | – |
| TXT | @ | `google-site-verification=k-l4quDkRbXeeIJNICMhsuAaNO5dUU993OHGcjWxdQg` | – |
| TXT | _dmarc | `v=DMARC1; p=none;` | – |

### rwwertec.de
| Typ | Name | Wert | Proxy |
|---|---|---|---|
| MX | @ | `mx00.ionos.de` (Prio 10) | DNS only |
| MX | @ | `mx01.ionos.de` (Prio 10) | DNS only |
| TXT | @ | `v=spf1 include:_spf-eu.ionos.com ~all` | – |
| TXT | _dmarc | `v=DMARC1; p=none;` | – |

> Der `google-site-verification`-Eintrag gehört zur Google Search Console.
> Fehlt er, verlierst du die Verifizierung der Domain.

Die alten **A-Einträge** auf `217.160.0.25` (IONOS-Server) werden in Schritt 4
durch Cloudflare Pages ersetzt — die musst du nicht von Hand anlegen.

## Schritt 4 — Die beiden Seiten hochladen

Im Cloudflare-Dashboard: **Workers & Pages → Create → Pages → Upload assets**
(nicht "Connect to Git" — du brauchst kein Repository).

### Projekt 1: ftmanager
- Projektname: `ftmanager`
- Ordner hochladen: `C:\AnwendungenZwei\IOnosSi\_deploy_ftmanager`
- Danach: **Custom domains → Set up a custom domain** → `ftmanager.de`
- Nochmal für `www.ftmanager.de`

### Projekt 2: rwwertec
- Projektname: `rwwertec`
- Ordner hochladen: `C:\AnwendungenZwei\IOnosSi\_deploy_rwwertec`
- Custom domains → `rwwertec.de` und `www.rwwertec.de`

Cloudflare legt die nötigen DNS-Einträge dabei selbst an.

## Schritt 5 — SSL prüfen

SSL/TLS → Overview → Modus **Full** (nicht "Flexible").
Das Zertifikat wird automatisch ausgestellt und erneuert — damit ist
`https://rwwertec.de` wieder erreichbar. Das war der Grund, warum die
Buttons "Jetzt kostenlos testen" und "Live-Demo starten" bisher ins Leere liefen.

Unter SSL/TLS → Edge Certificates zusätzlich **"Always Use HTTPS"** aktivieren.

## Schritt 6 — Testen, dann erst bei IONOS kündigen

Prüfen:
- [ ] `https://ftmanager.de` lädt
- [ ] `https://ftmanager.de/app/` startet die App
- [ ] APK-Download funktioniert (`FtvRw_1_1.0.apk`)
- [ ] PDF-Download funktioniert
- [ ] `https://rwwertec.de` startet die App
- [ ] Impressum und Datenschutz auf beiden Domains erreichbar
- [ ] **Test-E-Mail an ein Postfach der Domains senden und empfangen**

Erst wenn alles läuft: IONOS-Hosting kündigen bzw. auf Domain-Tarif wechseln.

---

## Offene Punkte

**TMS-Trial-Lizenz.** `Project1.js` zeigt beim Start
`alert("Application created with an unlicensed trial version of software")`.
Betrifft beide Seiten, da identischer Build (md5 `d36b7e33…`).
Lösung nur über eine TMS-Web-Core-Lizenz und neuen Build.
Danach die neue `Project1.js` in **beide** Ordner kopieren.

**Doppelte App.** Die App liegt in `_deploy_ftmanager\app\` und in
`_deploy_rwwertec\`. Wenn `/app/` nicht gebraucht wird: Ordner löschen und
die Buttons "Starten" und "🏢 Jetzt starten" in `index.html` auf
`https://rwwertec.de` umstellen.

**Impressum.** Die Texte nennen § 55 RStV und TMG. Beide sind überholt
(MStV seit 2020, DDG seit Mai 2024). Keine Eile, aber bei Gelegenheit anpassen.
