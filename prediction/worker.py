import datetime
import json
from prediction import predict
import psycopg2
from redis import Redis
from rows import DumpRow, PredictionRow
import time


def predict_thread(data, kind, cursor, connection):
    prediction_table, rows_table = data["prediction_table"], data["rows_table"]
    station_id = data["station_id"]

    dump_rows = DumpRow.fetch_all(cursor, rows_table, station_id)
    prediction_rows = PredictionRow.fetch_all(cursor, rows_table, data["ids"])

    predictions = predict(data, dump_rows, prediction_rows, kind)

    results = []

    for prediction in predictions:
        timestamp = datetime.datetime.utcfromtimestamp(prediction["timestamp"])
        timestamp = datetime.datetime(timestamp.year, timestamp.month, timestamp.day, timestamp.hour)
        now = datetime.datetime.utcnow()

        result = "(%d, TIMESTAMP '%s', %d, '%s', TIMESTAMP '%s', TIMESTAMP '%s')" % (station_id, timestamp, prediction["value"], kind, now, now)
        results.append(result)

    cursor.execute("INSERT INTO %s (station_id, datetime, available_bikes, kind, created_at, updated_at) VALUES %s" % (prediction_table, ", ".join(results)))
    connection.commit()


if __name__ == '__main__':
    print "Connecting to PostgreSQL..."

    connection = psycopg2.connect("dbname=velib_development user=velib password=velib")
    cursor = connection.cursor()

    print "Connecting to Redis..."

    redis = Redis(host="localhost", port=6379, db=0)

    pubsub = redis.pubsub()
    pubsub.subscribe("prediction")

    print "Subscribed to 'prediction' channel"

    for item in pubsub.listen():
        if item["type"] != "message":
            continue

    data = json.loads(item["data"])

    print "Received data for station id: %s..." % str(data["station_id"])

    for kind in ("scikit_lasso", "scikit_ridge"):
        predict_thread(data, kind, cursor, connection)

    cursor.close()
    connection.close()
