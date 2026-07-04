import threading

# confluent kafka avro data consumer
from confluent_kafka import DeserializingConsumer # type: ignore
from confluent_kafka.schema_registry import SchemaRegistryClient  # type: ignore
from confluent_kafka.schema_registry.avro import AvroDeserializer # type: ignore
from confluent_kafka.serialization import StringDeserializer # type: ignore

# defining the kafka configurations
kafka_config = {
    'bootstrap.servers' : 'pkc-619z3.us-east1.gcp.confluent.cloud:9092',
    'sasl.mechanisms' : 'PLAIN',
    'security.protocol' : 'SASL_SSL',
    'sasl.username' : 'TWLKUZJZBP3MNES4', # kafka api key
    'sasl.password' : 'cfltW8kv2CJrHr9xX44qQz3Gc/8M1+Q5FZz7lef9D09+TRj8CLITcBWrXdlyqv6Q', # kafka api secret
    'group.id': 'group2',
    'auto.offset.reset': 'latest' # here we have created that latest one , if we want earliset also we can ge
    # 'auto.offset.reset': 'earliest' # it will read from first offset.
}

# schema_registry_client
schema_registry_client = SchemaRegistryClient({
    'url': 'https://psrc-1o8pr0d.us-east1.gcp.confluent.cloud',
    'basic.auth.user.info': '{}:{}'.format('WT2IL2LOUPHT2X4M', 'cflt98jT5pRlOSZzwtmxRRXFuum2zvadZsmZy7SxSeEYUplXEng/fB3czQbrwJHA')
})

# Fetch the latest Avro schema for the value
subject_name = 'retail_data_dev-value'
latest_schema = schema_registry_client.get_latest_version(subject_name)
schema_str = latest_schema.schema.schema_str

# Create Avro DeSerializer for the value
key_deserializer = StringDeserializer('utf-8')
value_deserializer = AvroDeserializer(schema_registry_client, schema_str)

# Define the DeserializingConsumer
consumer = DeserializingConsumer({
    'bootstrap.servers': kafka_config['bootstrap.servers'],
    'security.protocol': kafka_config['security.protocol'],
    'sasl.mechanisms': kafka_config['sasl.mechanisms'],
    'sasl.username': kafka_config['sasl.username'],
    'sasl.password': kafka_config['sasl.password'],
    'key.deserializer': key_deserializer,
    'value.deserializer': value_deserializer,
    'group.id': kafka_config['group.id'],
    'auto.offset.reset': kafka_config['auto.offset.reset']
}
)
# subscribe to the topic
consumer.subscribe(['retail_data_dev'])

# continullay read messages from kafka , we running through infinite loop to check Everytime.
try:
    while True:
        msg = consumer.poll(timeout=1.0) # here how many seconds to wait for messages.
        if msg is None:
            continue
        if msg.error():
            print("----Message consumption error: {}".format(msg.error()))
            continue
        print('Successfully consumed record with key {} and value {}'.format(msg.key(), msg.value()))
except KeyboardInterrupt:
    pass
finally:
    consumer.close()
    print("Consumer closed")

