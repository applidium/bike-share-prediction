class Row:
    def __init__(self, result):
        self.result = result

    def to_json(self):
        return { column: float(value) for column, value in zip(Row.columns(), self.result) }

    @classmethod
    def columns(self):
        return ["open", "weather", "temperature", "wind_speed", "humidity", "hour", "minute",
            "day_of_week", "week_number", "season", "weekend", "holiday", "available_bikes"]


class DumpRow(Row):
    @classmethod
    def fetch_all(self, cursor, table, station_id):
        cursor.execute("SELECT %s FROM %s WHERE type = 'DumpDataPointRow' AND station_id = %d ORDER BY created_at" % (", ".join(Row.columns()), table, station_id))

    return [DumpRow(result) for result in cursor.fetchall()]


class PredictionRow(Row):
    def to_json(self):
        return { column: float(value) for column, value in zip(PredictionRow.columns(), self.result) }

    @classmethod
    def fetch_all(self, cursor, table, ids):
        _ids = [str(i) for i in ids]
        cursor.execute("SELECT %s FROM %s WHERE type = 'PredictionDataPointRow' AND id IN (%s)" % (", ".join(PredictionRow.columns()), table, ",".join(_ids)))

    return [PredictionRow(result) for result in cursor.fetchall()]

    @classmethod
    def columns(self):
        return Row.columns()[:-1]  # do not take `available_bikes` column
