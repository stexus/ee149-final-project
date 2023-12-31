import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

class Leader:
    def __init__(self, dt):
        self.path = lambda t: np.array([0, 0])
        self.dt = dt
        self.t = 0
        self.goto(self.t)

    def set_path(self, path):
        self.path = path
        self.goto(self.t)

    def goto(self, t):
        self.pos = self.path(t)
        self.vel = (self.path(t + self.dt) - self.pos) / self.dt
        if t < self.dt / 2:
            last_vel = np.array([0.0, 0.0])
        else:
            last_vel = (self.pos - self.path(t - self.dt)) / self.dt
        self.acc = (self.vel - last_vel) / self.dt
        self.t = t

    def step(self):
        self.goto(self.t + self.dt)

    def sense(self, noise_p, noise_v):
        n_pos = np.random.normal(scale=noise_p, size=(2,))
        n_vel = np.random.normal(scale=noise_v, size=(2,))
        return self.pos + n_pos, self.vel + n_vel

    def sense_raw(self, follower_acc, follower_pos, noise_a, noise_d):
        true_rel_acc = self.acc - follower_acc
        true_dist = np.linalg.norm(self.pos - follower_pos)
        return true_rel_acc + np.random.normal(scale=noise_a, size=(2,)), \
               true_dist + np.random.normal(scale=noise_d)

class Follower:
    def __init__(self, pos0, dt, leader_speed, follow_distance):
        self.pos = np.array(pos0)
        self.vel = np.array([0.0, 0.0])
        self.last_vel = self.vel
        self.dt = dt
        self.speed = 1
        self.leader_speed = leader_speed
        self.follow_distance = follow_distance
        self.leader_path = []

    def follow(self, leader):
        acc = (self.vel - self.last_vel) / self.dt
        rel_acc, dist = leader.sense_raw(acc, self.pos, 0.5, 0.3)

        self.pos += self.vel * self.dt
        self.last_vel = self.vel
        self.vel += rel_acc * self.dt

        self.leader_path.append(np.copy(leader.pos))

        target_speed = self.leader_speed + np.linalg.norm(leader.vel)
        self.speed += 0.1 * (target_speed - self.speed)

        closest_point = min(self.leader_path, key=lambda x: np.linalg.norm(x - self.pos))
        direction = closest_point - self.pos
        direction /= np.linalg.norm(direction)

        projected_pos = self.pos + self.speed * self.dt * direction

        leader_distance_forward = np.linalg.norm(leader.pos - projected_pos)

        if leader_distance_forward < self.follow_distance:
            self.pos = projected_pos

class Map:
    def __init__(self, dims, x_min, x_max, y_min, y_max):
        self.map = np.zeros(dims)
        self.dims = dims
        self.x_min = x_min
        self.x_max = x_max
        self.y_min = y_min
        self.y_max = y_max
        self.x_range = x_max - x_min
        self.y_range = y_max - y_min

    def clear(self):
        self.map *= 0

    def draw(self, actor, id):
        i = int(((self.y_max - actor.pos[1]) / self.y_range) * self.dims[1])
        j = int(((actor.pos[0] - self.x_min) / self.x_range) * self.dims[0])
        if not (self.x_min < actor.pos[0] < self.x_max) or not (self.y_min < actor.pos[1] < self.y_max):
            print("WARNING:", type(actor).__name__, "out of bounds!")
            return
        self.map[i, j] = id

    def fade(self, frac):
        self.map *= (1.0 - frac)

    def show(self, ax):
        return ax.imshow(self.map)


class Sim:
    def __init__(self, follower_start, dt, map_res, map_bound, leader_speed, follow_distance):
        self.t = 0
        self.dt = dt
        self.leader = Leader(self.dt)
        self.followers = [Follower(follower_start, self.dt, leader_speed, follow_distance)]
        self.map = Map((map_res, map_res), -map_bound, map_bound, -map_bound, map_bound)

    def set_leader_path(self, path):
        self.leader.set_path(path)

    def run(self, T):
        T_end = self.t + T
        while self.t < T_end:
            for f in self.followers:
                f.follow(self.leader)
                plt.pause(0.01)
            self.leader.step()
            self.t += self.dt

    def run_and_show(self, T, fade=0.0):
        def step(f):
            for f in self.followers:
                f.follow(self.leader)
                self.map.draw(f, -1)
                self.map.fade(fade)
            self.map.draw(self.leader, 1)
            artist = self.map.show(ax)
            self.leader.step()
            self.t += self.dt

            return artist,

        fig, ax = plt.subplots()
        anim = FuncAnimation(fig, step, frames=np.arange(0, T, self.dt), repeat=False, blit=True, interval=int(1000 * self.dt))
        plt.show()

if __name__ == "__main__":
    sim = Sim([1.5, -0.3], 0.02, 100, 4, leader_speed=1.0, follow_distance=10.0)

    sim.set_leader_path(
        lambda t: np.array([
            1.5 * np.cos(t),
            np.sin(2 * t)
        ])
    )

    sim.run_and_show(4 * np.pi, fade=0.01)
