package example.syncSrv;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Bucket;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.StorageClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Paths;
import java.time.Duration;

public class Main {
    public static void main(String[] args) {
        FileInputStream account = null;
        try {
            account = new FileInputStream("./SyncServer/congress-app-c6d54-firebase-adminsdk-l84cs-e41c97bcf7.json");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        FirebaseOptions options = null;
        try {
            options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(account))
                    .setStorageBucket("congress-app-c6d54.appspot.com")
                    .build();
        } catch (IOException exception) {
            exception.printStackTrace();
        }
        FirebaseApp.initializeApp(options);

        BufferedImage bImage = null;
        try {
            bImage = ImageIO.read(new File("./SyncServer/example.jpg"));
        } catch (IOException exception) {
            exception.printStackTrace();
        }
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        try {
            ImageIO.write(bImage, "jpg", bos );
        } catch (IOException exception) {
            exception.printStackTrace();
        }
        byte [] data = bos.toByteArray();

        Bucket bucket = StorageClient.getInstance().bucket();
        bucket.create("gunDestination.jpg", data);

        bucket.get("gunDestination.jpg").downloadTo(Paths.get("./SyncServer/downloaded.jpg"));

        System.out.println(FirebaseApp.getInstance().getName());

//        Flux.interval(Duration.ofSeconds(10)).flatMap(num -> runLearning())
//                .doOnNext(useless -> System.out.println("Running AI detection"))
//                .blockLast();
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