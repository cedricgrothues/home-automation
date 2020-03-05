use warp::Filter;

#[tokio::main]
async fn main() {
    let state = warp::path("devices")
        .and(warp::path::param())
        .and(warp::get())
        .map(|id: String| format!("state for device: {}", id));

    let update = warp::path("devices")
        .and(warp::path::param())
        .and(warp::put())
        .map(|id: String| format!("update device: {}", id));

    warp::serve(state.or(update)).run(([0u8; 4], 4003)).await;
}
