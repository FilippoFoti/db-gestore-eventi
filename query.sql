-- Selezionare tutti gli eventi gratis, cioè con prezzo nullo (19)
SELECT `price` FROM `events` WHERE `price` IS NULL;

-- Selezionare tutte le location in ordine alfabetico (82)
SELECT `name` FROM `locations` ORDER BY `name`;

-- Selezionare tutti gli eventi che costano meno di 20 euro e durano meno di 3 ore (38)
SELECT `price`, `duration` FROM `events` WHERE `price` < 20 AND `duration` < '03:00:00';

-- Selezionare tutti gli eventi di dicembre 2023 (25)
SELECT `start` FROM `events` WHERE `start` BETWEEN '2023-12-01 00:00:00' AND '2023-12-31 23:59:59';

-- Selezionare tutti gli eventi con una durata maggiore alle 2 ore (823)
SELECT `duration` FROM `events` WHERE `duration` > '02:00:00'; -- (946)

-- Selezionare tutti gli eventi, mostrando nome, data di inizio, ora di inizio, ora di fine e durata totale (1040)
SELECT `name`, `start`, `duration` FROM `events`;

-- Selezionare tutti gli eventi aggiunti da “Fabiano Lombardo” (id: 1202) (132)
SELECT * FROM `events` WHERE `user_id` = 1202;

-- Selezionare il numero totale di eventi per ogni fascia di prezzo (81)
SELECT `price` FROM `events` GROUP BY `price`;

-- Selezionare tutti gli utenti admin ed editor (9)
SELECT * FROM `users` WHERE `role_id` = 1 OR `role_id` = 2;

-- Selezionare tutti i concerti (eventi con il tag “concerti”) (72)
SELECT * FROM `event_tag` WHERE `tag_id` = 1;

-- Selezionare tutti i tag e il prezzo medio degli eventi a loro collegati (11)
SELECT tags.name, events.name, AVG(events.price) FROM `tags` JOIN `event_tag` ON event_tag.event_id = tags.id JOIN `events` ON events.id = event_tag.event_id GROUP BY tags.id, tags.name;

-- Selezionare tutte le location e mostrare quanti eventi si sono tenute in ognuna di esse (82)
SELECT locations.name, COUNT(events.id) FROM `events` JOIN `locations` ON locations.id = events.location_id GROUP BY locations.name;

-- Selezionare tutti i partecipanti per l’evento “Concerto Classico Serale” (slug: concerto-classico-serale, id: 34) (30)
SELECT events.name, users.last_name FROM `events` JOIN `bookings` ON bookings.event_id = events.id JOIN `users` ON users.id = bookings.user_id WHERE events.id = 34;

-- Selezionare tutti i partecipanti all’evento “Festival Jazz Estivo” (slug: festival-jazz-estivo, id: 2) specificando nome e cognome (13)
SELECT events.name, users.first_name, users.last_name FROM `events` JOIN `bookings` ON bookings.event_id = events.id JOIN `users` ON users.id = bookings.user_id WHERE events.id = 2;

-- Selezionare tutti gli eventi sold out (dove il totale delle prenotazioni è uguale ai biglietti totali per l’evento) (18)
SELECT events.id, events.name FROM `events` WHERE events.total_tickets = ( SELECT COUNT(*) FROM `bookings` WHERE bookings.event_id = events.id);

-- Selezionare tutte le location in ordine per chi ha ospitato più eventi (82)
SELECT locations.name, COUNT(events.location_id) FROM `locations` JOIN `events` ON locations.id = events.location_id GROUP BY locations.id ORDER BY COUNT(events.location_id) DESC;

-- Selezionare tutti gli utenti che si sono prenotati a più di 70 eventi (74)
SELECT users.id, users.first_name, users.last_name, COUNT(bookings.id) FROM `users` JOIN `bookings` ON users.id = bookings.user_id GROUP BY users.id, users.first_name, users.last_name HAVING COUNT(bookings.id) > 70;

-- Selezionare tutti gli eventi, mostrando il nome dell’evento, il nome della location, il numero di prenotazioni e il totale di biglietti ancora disponibili per l’evento (1040)
SELECT events.id, events.name AS `event`, locations.name AS `location`, COUNT(bookings.event_id) AS `bookings`, (events.total_tickets - COUNT(bookings.event_id)) AS tickets_available FROM `events` JOIN `locations` ON locations.id = events.location_id JOIN `bookings` ON bookings.event_id = events.id GROUP BY events.id, events.name, locations.name
