---
seo:
  title: Getting Started with Apache Kafka and Python
  description: SEO description
hero:
  title: Getting Started with Apache Kafka and Python
  description: Hero description
---

# Getting Started with Apache Kafka and Python

## Introduction

In this tutorial, you will build Python client applications which
produce and consume messages from an Apache Kafka® cluster. The tutorial
will walk you through setting up a local Kafka cluster if you do not
already have access to one.

*Continue*: I'm ready to start

## Prerequisites

This guide assumes that you already have
[Python](https://www.python.org/downloads/) installed.

(If you're using Python 2.7, you'll also need to install
[Pip](https://pypi.org/project/pip/) and
[VirtualEnv](https://pypi.org/project/virtualenv/) separately.)

*Continue*: I have the required software

## Create Project

Create a new directory anywhere you'd like for this project:

```sh
mkdir kafka-python-getting-started && cd kafka-python-getting-started
```

Create and activate a Python virtual environment to give yourself a
clean, isolated workspace:

```sh
virtualenv env

source env/bin/activate
```

#### Python 3.x

Install the Kafka library:

```sh
pip install confluent-kafka
```

#### Python 2.7

First install [librdkafka](https://github.com/edenhill/librdkafka#installation).

Then install the python libraries:

```sh
pip install configparser\
pip install confluent-kafka
```

## Kafka Setup

We are going to need a Kafka Cluster for our client application to
operate with. This dialog can help you configure your Confluent Cloud
cluster, create a Kafka cluster for you, or help you input an existing
cluster bootstrap server to connect to.

<section class="choice-cloud">

![](media/image1.png)

Paste your Confluent Cloud bootstrap server setting here and the
tutorial will fill it into the appropriate configuration for
you.

![](media/image6.png)

You can obtain your Confluent Cloud Kafka cluster bootstrap server
configuration using the [Confluent Cloud UI](https://confluent.cloud/).

</section>

<section class="choice-local">

![](media/image3.png)

Paste the following file into a `docker-compose.yml` file:

```yaml file=../docker-compose.yml
```


Now start the Kafka broker with: `docker compose up -d`

</section>

<section class="choice-other">

![](media/image2.png)

Paste your Kafka cluster bootstrap server URL here and the tutorial will
fill it into the appropriate configuration for you.

</section>

*Continue*: My Kafka cluster is ready

## Configuration

Paste the following configuration data into a file at `getting_started.ini`

<section class="choice-cloud">

The below configuration includes the required settings for a connection
to Confluent Cloud including the bootstrap servers configuration you
provided. 

![](media/image5.png)

When using Confluent Cloud you will be required to provide an API key
and secret authorizing your application to produce and consume. You can
use the [Cloud UI](https://confluent.cloud/) to create a key for
you.

Take note of the API Key and secret and insert the values in the
appropriate location in the configuration file.

```ini file=getting_started_cloud.ini
```

</section>

<section class="choice-local">

```ini file=getting_started_local.ini
```

</section>

<section class="choice-other">

The below configuration file includes the bootstrap servers
configuration you provided. If your Kafka Cluster requires different
client security configuration, you may require [different
settings](https://kafka.apache.org/documentation/#security).

```ini file=getting_started_other.ini
```

</section>

*Continue*: My configuration is ready

## Create Topic

Events in Kafka are organized and durably stored in named topics. Topics
have parameters that determine the performance and durability guarantees
of the events that flow through them.

Create a new topic, purchases, which we will use to produce and consume
events.

<section class="choice-cloud">

![](media/image4.png)

When using Confluent Cloud, you can use the [Cloud
UI](https://confluent.cloud/) to create a topic. Create a topic
with 1 partition and defaults for the remaining settings.

</section>


<section class="choice-local">

We'll use the `kafka-topics` command located inside the local running
Kafka broker:

```sh file=../create-topic.sh
```

</section>


<section class="choice-other">

Depending on your available Kafka cluster, you have multiple options
for creating a topic. You may have access to [Confluent Control
Center](https://docs.confluent.io/platform/current/control-center/index.html),
where you can [create a topic with a
UI](https://docs.confluent.io/platform/current/control-center/topics/create.html). You
may have already installed a Kafka distribution, in which case you can
use the [kafka-topics command](https://kafka.apache.org/documentation/#basic_ops_add_topic).
Note that, if your cluster is centrally managed, you may need to
request the creation of a topic from your operations team.

</section>

*Continue*: My topic is created

## Build Producer

Paste the following Python code into a file located at `producer.py`:

```python file=producer.py
```

## Build Consumer

Paste the following Python code into a file located at `consumer.py`:

```python file=consumer.py
```

## Produce Events

Make the producer script executable, and run it:

```sh
chmod u+x producer.py

./producer.py getting_started.ini
```

You should see output that resembles:

```
Produced event to topic purchases: key = jsmith value = batteries
Produced event to topic purchases: key = jsmith value = book
Produced event to topic purchases: key = jbernard value = book
Produced event to topic purchases: key = eabara value = alarm clock
Produced event to topic purchases: key = htanaka value = t-shirts
Produced event to topic purchases: key = jsmith value = book
Produced event to topic purchases: key = jbernard value = book
Produced event to topic purchases: key = awalther value = batteries
Produced event to topic purchases: key = eabara value = alarm clock
Produced event to topic purchases: key = htanaka value = batteries
10 events were produced to topic purchases.
```

## Consume Events

Make the consumer script executable and run it:

```sh
chmod u+x consumer.py

./consumer.py getting-started.ini
```

You should see output that resembles:

```
Consumed event from topic purchases: key = sgarcia value = t-shirts
Consumed event from topic purchases: key = htanaka value = alarm clock
Consumed event from topic purchases: key = awalther value = book
Consumed event from topic purchases: key = sgarcia value = gift card
Consumed event from topic purchases: key = eabara value = t-shirts
Consumed event from topic purchases: key = eabara value = t-shirts
Consumed event from topic purchases: key = jsmith value = t-shirts
Consumed event from topic purchases: key = htanaka value = batteries
Consumed event from topic purchases: key = htanaka value = book
Consumed event from topic purchases: key = sgarcia value = book
Waiting...
Waiting...
Waiting...
```

The consumer will wait indefinitely for new events. You can kill the
process off (with `ctrl+C`), or experiment by starting a separate terminal
window and re-running the producer.

## Where next?

- For information on testing in the Kafka ecosystem, check out the
  testing page.
- If you're interested in using streaming SQL for data creation,
  processing, and querying in your applications, check out the
  ksqlDB course.
- Interested in taking event streaming applications to production?
  Check out the monitoring page.
