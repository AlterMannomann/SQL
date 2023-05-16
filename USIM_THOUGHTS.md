Die Energieattribute breite sich wie Wellen aus.
Plancklänge für Plancklänge, wir müssen also wissen, wer uns, positionsmässig am nächsten ist: Childs und Parent

Wir brauchen eine Funktion, die jedes Child und jeden Parent
mit der Energie reagieren lässt und dann den jeweilgen Knoten
veranlasst, seinerseits Childs und Parents zu beliefern.

Über die Parents kann es ein Feedback geben, dass ggf. wünschenswert
ist.
Der einzige Knoten, der ausgeschlossen ist, ist der Knoten, der
die Energieattribute direkt geliefert hat (keine Results an diesen
Knoten).

actio - attribute werden an alle child/parent Knoten ausgeliefert, die nicht Lieferant der attribute sind.

dies löst bei jedem Knoten dieselbe Reaktion aus

reactio - die werte nach berechnung der inputs, die an andere Knoten weitergeliefert werden.

pro point ausführen
<-input actio verarbeiten
->output reactio abgeben an child/parent, aber nicht sender

Auf DB Ebene brauche ich eine Trigger Tabelle, die Aktionen in der richtigen Reihenfolge auslöst.

DB Trigger sind hier zu wenig kontrollierbar und es besteht die Gefahr das die DB sich tottriggert.

* Planck Tick in der der Trigger ausgeführt werden muss
* Reihenfolge innerhalb des Tick oder Trigger die als nächstes ausgeführt werden
* Status wait, start/run, success, error

FEHLER
* zur Zeit infinity handling