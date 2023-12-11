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
        if (t < self.dt / 2):
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
               true_dist    + np.random.normal(scale=noise_d)

class Follower:
    def __init__(self, pos0, dt):
        self.pos = np.array(pos0)
        self.vel = np.array([0.0, 0.0])
        self.acc = np.array([0.0, 0.0])
        self.last_vel = self.vel.copy()
        self.dt = dt
        self.leader_rel_vel = np.array([0.0, 0.0])
        self.leader_rel_pos = np.array([0.0, 0.3])
        self.ds = []
        self.desired_dist = 0.5

    def follow(self, leader):
        self.acc = (self.vel - self.last_vel) / self.dt

        leader_rel_acc, dist = leader.sense_raw(self.acc, self.pos, 1.0, 0.0)
        self.leader_rel_vel += leader_rel_acc*self.dt
        self.leader_rel_pos += self.leader_rel_vel*self.dt + 0.5*leader_rel_acc*self.dt*self.dt
        self.ds.append(dist)

        self.Kp = 10
        self.Kd = 0.1
        # self.acc = leader_rel_acc # + self.leader_rel_pos*self.Kp + self.leader_rel_vel*self.Kd
        # self.vel += self.acc*self.dt
        self.last_vel[:] = self.vel[:]
        print(dist)
        self.vel += self.leader_rel_vel
        self.pos += self.vel*self.dt

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
    def __init__(self, follower_start, dt, map_res, map_bound):
        self.t = 0
        self.dt = dt
        self.leader = Leader(self.dt)
        self.followers = [Follower(follower_start, self.dt)]
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
        anim = FuncAnimation(fig, step, frames=np.arange(0, T, self.dt), repeat=False, blit=True, interval=int(1000*self.dt))
        plt.show()

if __name__ == "__main__":
    sim = Sim([1.5, -0.3], 0.02, 100, 4)

    sim.set_leader_path(
        lambda t: np.array([
            1.5*np.cos(t),
            np.sin(2*t)
        ])
    )
    # sim.set_leader_path(
    #     lambda t: np.array([
    #         -np.pi+t,
    #         -0.1*((t-np.pi)**2)+1
    #     ])
    # )

    sim.run_and_show(2*np.pi, fade=0.01)

    plt.figure()
    plt.plot(sim.followers[0].ds)
    plt.show()