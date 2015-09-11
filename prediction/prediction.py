from datetime import datetime, timedelta
import time
import json
import numpy as np
import pandas as pd
from sklearn import linear_model

# returns unix timestamp of `origin`datetime + `hour` padding
def timestamp(origin, hour):
    return int(time.mktime((origin + timedelta(hours=hour)).timetuple()))

def predict_for_dump(rows_dumped, rows_to_predict, kind):
    data = rows_dumped

    features = data.columns[1:]
    targets = np.array(data['available_bikes']).astype(int)

    classifiers = {
        "scikit_lasso": linear_model.Lasso(alpha=0.1),
        "scikit_ridge": linear_model.Ridge(alpha=0.1)
    }

    clf = classifiers[kind] if kind in classifiers else classifiers["scikit_lasso"]
    clf.fit(data[features], targets)

    rows = clf.predict(rows_to_predict)

    return [int(row) for row in rows]

def predict(data, dump_rows, prediction_rows, kind):
    hours_range = data["hours_range"]

    origin = datetime.fromtimestamp(data["action_timestamp"])
    timestamps = [timestamp(origin, i) for i in xrange(hours_range+1)]

    _rows = json.dumps([row.to_json() for row in dump_rows])
    rows_dumped = pd.read_json(_rows)

    _rows = json.dumps([row.to_json() for row in prediction_rows])
    rows_to_predict = pd.read_json(_rows)

    predictions = predict_for_dump(rows_dumped, rows_to_predict, kind)

    return [{ "timestamp": timestamps[i], "value": value } for i, value in enumerate(predictions)]
