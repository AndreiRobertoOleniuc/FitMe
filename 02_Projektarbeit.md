---
marp: true
title: Projektarbeit
paginate: true
style: |
  @import "./fhnw.css"
backgroundColor: #ddd
---

<!-- @format -->

# App-Ideen für Studenten

Wintersemester FHNW 2024/2025

Letzter Kurstag: 16.01.2025
Abgabe: 30.01.2025 eoB

---

## Mal was anderes

- Überlegt Euch selbst eine App oder sucht Euch eine aus den folgenden Ideen heraus (AI erzeugt und nachbearbeitet ;)
- Wenn Ihr selbst eine Idee habt, schickt mir die Punkte (angelehnt an die Beispiele der Folgeseiten) bis in 2 Wochen und ich korrigiere oder erweitere diese. Bitte teilt mir auch mit, wie gross das Team ist wegen der Machbarkeit und wer in Eurer Gruppe dabei ist. Am besten per Teams Chat.
- Bitte gebt Euch einen Namen ... etwa "TEAM RECIPE" wenn Ihr den Personal Recipe Manager angehen wollt.

- Wir werden im Dialog schauen, ob die Aufgabe, die Ihr Euch stellt, auch für die Gruppengrösse machbar ist

---

# Bewertungskriterien

- **Funktionalität** (20%): Die App soll die vorgegebenen Funktionen fehlerfrei erfüllen.

- **Architektur** (40%): Verwendet striktes **_(!!!)_** _MVVM_ und _Clean Code_. Das bedeutet dass im View **NUR** angezeigt wird. Im ViewModel wird **NUR** für das View aufbereitet aufbereitet und vom Model die Infos geholt. Das Model (nicht zu verwechseln mit der Datenstruktur, die nur Teil des Models ist) selbst nutzt Services um Daten zu holen und zu verarbeiten und kann selbst Business Logik enthalten.

- **Design** (10%): Die App sollte ein ansprechendes Design haben und den Usability Kriterien von Apple entsprechen

- **Code Qualität** (30%): Der Code sollte gut strukturiert, wart- und testbar sein. Jede Model- und ViewModel-Funktion soll im XCTest mit sinnvollen Werten getestet sein. Wenn aus dringenden Gründen "Hacks" notwendig sind, bitte dokumentieren.

---

# Grundsätze bei der Bewertung

- **Prozess**: Jede Änderung am Code oder in der Dokumentation wird in einem Git Repository verwaltet. Jeder Teilnehmer sollte ungefähr denselben Beitrag zum Projekt leisten (sonst gibt es Abzüge)

- **Separation of Concerns** (10%): Jede Klasse, Methode sollte nur eine Verantwortung haben und Funktionen sollten klein und wiederverwendbar sein.

- **No Packages**: Verwendet keine Packages die nicht in der Swift Standard Library enthalten sind. Sollte eines nötig sein, bitte **VORHER** begründen oder sofort die Kommunikation mit mir suchen.

- **Sonstige Infos**: API keys bitte NICHT in die Repo schieben. Zum Testen für mich per 2nd factor e.g. per iMessage oder Mail an mich schicken. Ich werde sie NUR zum Testen verwenden

---

## Personal Recipe Manager 🥘

**Features:**

- Tab-basiertes Interface (Rezepte, Kategorien, Einkaufsliste)
- Rezepte nach Zutaten/Kategorien durchsuchen und filtern
- Detailansicht mit Zutaten, Schritten und Kochzeit
- Rezepte in SwiftData speichern
- Einkaufsliste aus ausgewählten Rezepten generieren

### **ab 2 Personen pro Team:**

- Zuletzt angesehenes Rezept und Tab-Auswahl speichern
- Kamera-Integration für Food-Fotos

### **ab 3 Personen:**

- Rezepte über das System-Share-Sheet teilen

---

## Fitness Workout Tracker 💪

**Features:**

- Verschiedene Workouts verfolgen
- Benutzerdefinierter Workout-Builder mit Übungsdatenbank
- Timer/Zähler für Übungen
- REST-Integration mit der Wger Workout API

### **ab 2 Personen pro Team:**

- Fortschrittsdiagramme mit Swift Charts
- Lokales Backup in SwiftData
- Historienansicht mit Kalenderintegration
- Workout-Historie und aktuelles Programm speichern

---

## Personal Finance Tracker 💰

**Features:**

- Dashboard mit Ausgabenübersicht
- Ausgaben mit Kategorien hinzufügen
- Monatliche Budgetplanung
- SwiftData für lokale Speicherung
- REST-Integration mit Währungsumrechnungs-API

### **ab 2 Personen pro Team:**

- Ausgabenanalyse mit Diagrammen
- Export-Funktionalität zu CSV
- Ausgewählten Zeitraum und Kategorie-Filter speichern

---

## Language Learning Flashcards 📚

**Features:**

- Eigene Karteikartensets erstellen
- System für wiederholtes Lernen (Spaced Repetition)
- Fortschrittsverfolgung
- SwiftData für Offline-Zugriff
- Lernfortschritt und aktuelles Kartenset speichern

### **ab 2 Personen pro Team:**

- Integration mit Übersetzungs-API
- Audioaussprache über System-TTS
- Export/Import von Kartensets

---

## Weather Journal App 🌤

**Features:**

- Integration mit der OpenWeatherMap-API
- Tägliche Wetteraufzeichnungen mit persönlichen Notizen
- Fotoanbindung für Wetterbedingungen
- Standortbasierte Wetterverfolgung
- Offline-Unterstützung mit SwiftData

### **ab 2 Personen pro Team:**

- Wetterhistorie mit Diagrammen
- Unterstützung für mehrere Standorte

---

## Task Manager mit KI-Unterstützung 📋

**Features:**

- Grundlegende Aufgabenverwaltung
- Integration mit OpenAI für Aufgaben-Vorschläge
- Aufgaben-Kategorisierung und Priorisierung
- Fälligkeitsbenachrichtigungen
- SwiftData für lokale Speicherung

### **ab 2 Personen pro Team:**

- Aufgaben-Sharing-Funktionalität
- Fortschrittsverfolgung
- Filtereinstellungen und Ansichtsstatus speichern

---

## Personal Book Library 📚

**Features:**

- Integration mit der Google Books API
- Barcode-Scanner zum Hinzufügen von Büchern
- Benutzerdefinierte Sammlungen/Regale

### **ab 2 Personen pro Team:**

- Buchbewertungen und Rezensionen
- Offline-Modus mit SwiftData

### **ab 3 Personen:**

- Lesestatistiken
- Lesefortschritt-Tracker
- Aktuelles Buch und Regalauswahl speichern

---

## Habit Tracker mit sozialen Funktionen 🎯

Projekt für Fortgeschrittene 3-4 Personen Teams

**Features:**

- Tägliche Gewohnheiten erstellen und verfolgen
- Gewohnheiten über Firebase teilen
- Fortschrittsvisualisierung
- Streak-Zähler
- Lokales Backup mit SwiftData
- Erfolgssystem
- Tägliche Erinnerungen
- Aktuelle Gewohnheiten und Streaks speichern
