seo:
  title: Event Processing Application
  description: Event Processing Applications are composed of one or more connected Event Processors forming a processing topology for streams and tables.
---

# Event Processing Application
To create, read, process, and/or query the data in an [Event Streaming Platform](../event-stream/event-streaming-platform.md), developers typically implement Event Processing Applications (e.g., in the form of microservices).

## Problem
How can we build an application for data in motion that creates, reads, processes, and/or queries [Event Streams](../event-stream/event-stream.md)?

## Solution
![event-processing-application](../img/event-processing-application.png)

We build an Event Processing Application by composing one or more [Event Processors](../event-processing/event-processor.md) into an interconnected processing topology for [Event Streams](../event-stream/event-stream.md) and [Tables](../table/state-table.md). Here, the continuous output streams of one processor are the continuous input streams to one or more downstream processors. The event processors—and thus the application at large—are typically distributed (running across multiple instances) to allow for elastic, parallel, fault-tolerant processing of data in motion at scale.

For example, an application can read a stream of customer payments from an [Event Store](../event-storage/event-store.md) in an [Event Streaming Platform](../event-stream/event-streaming-platform.md), then filter payments for certain customers, and then aggregate those payments per country and per week. The processing mode is stream processing, i.e., data is continuously processed 24x7. As soon as new [Events](../event/event.md) are available, they are processed and propagated through the topology of [Event Processors](./event-processing/event-processor.md).

Event Processing Applications themselves can be composed, too, which is a common design pattern to implement event-driven architectures, powered by a fleet of applications and microservices. Here, the output of one application forms the input to one or more downstream applications. This is conceptually similar to the topology of [Event Processors](../event-processing/event-processor.md) within the same application, as described above. A key difference in practice, however, is that different applications are often built by different teams inside an organization. For example, a customer-facing application built by the Payments team is continuously feeding data via [Event Streams](../event-stream/event-stream.md) to an application built by the Anti-fraud team and to another application built by the Data Science team. 

Another difference is that [Event Streams](../event-stream/event-stream.md) for an application-to-application topology are generally externalized and persisted in an [Event Store](../event-storage/event-store.md) (e.g., they Payments application writes its [Events](../event/event.md) into a `payments` stream) for better application decoupling and [increased network effects](https://en.wikipedia.org/wiki/Network_effect) for the respective data. In contrast, processor-to-processor communication inside the same application may opt to not externalize/persist some of their [Event Streams](../event-stream/event-stream.md) for optimization purposes (e.g., the filtered stream of customer payments in the first example above may not need to be persisted into an [Event Store](../event-storage/event-store.md) before it is being aggregated, as the filtered stream can be trivially reconstructed from the full original stream of payments).

## Implementation
Apache Kafka® is the most popular [Event Streaming Platform](../event-stream/event-streaming-platform.md). There are several options for building Event Processing Aplications when using Kafka, and we'll show two here.

### ksqlDB
[ksqlDB](https://ksqldb.io) is a purpose-built event streaming database used to build Event Processing Applications. Using ksqlDB built-in support for [Tables](../table/table.md) and Streams (../event-stream/event-stream.md), you can build full Event Processing Applications using a familiar SQL syntax.

You can create [Tables](../table/table.md) and [Streams](../event-stream/event-stream.md) with Kafka topics as the storage layer built-in commands:
```sql
CREATE TABLE movies (ID INT PRIMARY KEY, title VARCHAR, release_year INT)
    WITH (kafka_topic='movies', partitions=1, value_format='avro');
CREATE STREAM ratings (MOVIE_ID INT KEY, rating DOUBLE)
    WITH (kafka_topic='ratings', partitions=1, value_format='avro');
```

Writing [Events](../event/event.md) is supported using `INSERT`:
```sql
INSERT INTO movies (id, title, release_year) VALUES (294, 'Die Hard', 1998);
INSERT INTO ratings (movie_id, rating) VALUES (294, 8.2);
```

Stream processing is accomplished using `SQL`. The command `CREATE STREAM .. AS SELECT ..` in the following example joins the `movies` table and the `ratings` stream to create a new stream of [Events](../event/event.md) that represent the `ratings` enriched with data from the `movies` table:
```sql
CREATE STREAM rated_movies
    WITH (kafka_topic='rated_movies',
          value_format='avro') AS
    SELECT ratings.movie_id as id, title, rating
    FROM ratings
    LEFT JOIN movies ON ratings.movie_id = movies.id;
```

### Kafka Streams
With the [Kafka Streams library](https://kafka.apache.org/documentation/streams/), you can use Java code to construct a stream processing topology to create the application. A similiar Kafka Streams example to the ksqlDB one above may look similar to: 
```java
Stream<String, Movie> movieStream = builder
  .stream(movieTopic)
  .map((key, movie) -> new KeyValue<>(movie.getId(), movie));

movieStream.to(rekeyedMovieTopic);

KTable<String, Movie> movies = builder.table(rekeyedMovieTopic);

KStream<String, Rating> ratings = builder
  .stream(ratingTopic)
  .map((key, rating) -> new KeyValue<>(rating.getId(), rating));

KStream<String, RatedMovie> ratedMovie = ratings.join(movies, new MovieRatingJoiner());

ratedMovie.to(ratedMoviesTopic);

return builder.build();
```

## Considerations
When building an Event Processing Application, it's important to generally confine the application to one problem domain.  While it's true the application can have any number of event processors, they should be closely related.

## References
* The [Event Streaming Platform](../event-stream/event-streaming-platform.md) pattern provides a higher level overview of how Event Processing Applications are utilized across the streaming platform.
* The [joining streams and tables in ksqlDB tutorial](https://kafka-tutorials.confluent.io/join-a-stream-to-a-table/ksql.html) provides a step by step example of event processing using `SQL`.
* [How to sum a stream of events](https://kafka-tutorials.confluent.io/create-stateful-aggregation-sum/ksql.html) is a ksqlDB tutorial for applying an aggregate function over an [Event Stream](../event-stream/event-stream.md). 
