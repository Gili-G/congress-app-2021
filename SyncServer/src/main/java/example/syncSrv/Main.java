package example.syncSrv;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.time.Duration;

public class Main {
    public static void main(String[] args) {
        Flux.interval(Duration.ofSeconds(10)).flatMap(num -> runLearning())
                .doOnNext(useless -> System.out.println("Running AI detection"))
                .blockLast();
    }

    public static Mono<?> runLearning() {
        return Mono.just("");
//        return Mono.fromRunnable(() -> {
//            try {
//                new ProcessBuilder()
//                        .inheritIO() //for debugging this prints all the output into the console
//                        .command("todo")
//                        .start()
//                        .waitFor();
//            } catch (InterruptedException | IOException e) {
//                e.printStackTrace();
//            }
//        });
    }
}
