# make sure to install the confluent kafka packages
# pip install confluent-kafka
# pip install pandas

import datetime
import threading
from decimal import *
from time import sleep
from uuid import uuid4,UUID
import time

# confluent kafka avro data producer
from confluent_kafka import SerializingProducer          # type: ignore
from confluent_kafka.serialization import StringSerializer  # type: ignore
from confluent_kafka.schema_registry.avro import AvroSerializer # type: ignore
from confluent_kafka.schema_registry import SchemaRegistryClient # type: ignore
import  pandas as pd

# defining the kafka configurations
kafka_config = {
    'bootstrap.servers' : 'pkc-619z3.us-east1.gcp.confluent.cloud:9092',
    'sasl.mechanisms' : 'PLAIN',
    'security.protocol' : 'SASL_SSL',
    'sasl.username' : 'TWLKUZJZBP3MNES4', # kafka api key
    'sasl.password' : 'cfltW8kv2CJrHr9xX44qQz3Gc/8M1+Q5FZz7lef9D09+TRj8CLITcBWrXdlyqv6Q', # kafka api secret
}

# create scheam registry cleint
schema_registry_client = SchemaRegistryClient({
    'url': 'https://psrc-1o8pr0d.us-east1.gcp.confluent.cloud',
    'basic.auth.user.info': '{}:{}'.format('WT2IL2LOUPHT2X4M', 'cflt98jT5pRlOSZzwtmxRRXFuum2zvadZsmZy7SxSeEYUplXEng/fB3czQbrwJHA')
})

# Fetch the latest Avro schema for the value
subject_name = 'retail_data_dev-value'
latest_schema = schema_registry_client.get_latest_version(subject_name)
schema_str = latest_schema.schema.schema_str
print(f"----Schema from Schema Registry")
print(schema_str)
print(f"-------------done--------------")

# Create Avro Serializer for the value
key_serializer = StringSerializer('utf-8')
value_serializer = AvroSerializer(schema_registry_client, schema_str)
# create serializing producer

producer = SerializingProducer({
    'bootstrap.servers' : kafka_config['bootstrap.servers'],
    'sasl.mechanisms' : kafka_config['sasl.mechanisms'],
    'security.protocol' : kafka_config['security.protocol'],
    'sasl.username' : kafka_config['sasl.username'], # kafka api key
    'sasl.password' : kafka_config['sasl.password'], # kafka api secret
    'key.serializer' : key_serializer,
    'value.serializer' : value_serializer
})

# load the csv file into pandas dataframe
df = pd.read_csv('retail_data.csv')
df = df.fillna('null')
print('----First 10 records from dataframe----')
print(df.head(10))
print('----Done----')

def delivery_report(err, msg):
    """
    Reports the failure or success of a message delivery.

    Args:
        err (KafkaError): The error that occurred on None on success.

        msg (Message): The message that was produced or failed.

    Note:
        In the delivery report callback the Message.key() and Message.value()
        will be the binary format as encoded by any configured Serializers and
        not the same object that was passed to produce().
        If you wish to pass the original object(s) for key and value to delivery
        report callback we recommend a bound callback or lambda where you pass
        the objects along.

    """
    if err is not None:
        print("----Message delivery failed for user record {}:{}".format(msg.key(),err))
        return 
    print('User record {} successfully produced to {} [{}] at offset {}'.format(
        msg.key(), msg.topic(), msg.partition(), msg.offset()))
    print("====================================")


# iterate over Datframe rows and produce to kafka
for index, row in df.iterrows():
    # create a dictionary from the row values
    data_value = row.to_dict()
    print(data_value)

    # produce to kafka
    producer.produce(
        topic = 'retail_data_dev',
        key = str(index),
        value = data_value,
        on_delivery = delivery_report
    )
    producer.flush()
    time.sleep(2)

print("All data succefully published to kafka system")