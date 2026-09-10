import io
import json
import logging

from fdk import response


def handler(ctx, data: io.BytesIO = None):
    name = "to Earth"
    try:
        body = json.loads(data.getvalue())
        name = body.get("name")
    except (Exception, ValueError) as ex:
        logging.getLogger().info('error parsing json payload: ' + str(ex))

    logging.getLogger().info("Inside Python Hello World function")
    return response.Response(
        ctx, response_data=json.dumps(
            {"message": "Welcome {0}".format(name)}),
        headers={"Content-Type": "application/json"}
    )
