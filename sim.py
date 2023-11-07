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
        self.t = t

    def step(self):
        self.goto(self.t + self.dt)

    def sense(self, noise_p, noise_v):
        n_pos = np.random.normal(scale=noise_p, size=(2,))
        n_vel = np.random.normal(scale=noise_v, size=(2,))
        return self.pos + n_pos, self.vel + n_vel

class Follower:
    def __init__(self, dt):
        self.pos = np.array([0.0, 0.0])
        self.vel = np.array([0.0, 0.0])
        self.dt = dt
        self.speed = 1

    def follow(self, leader):
        leader_pos, leader_vel = leader.sense(0.1, 0.3)
        self.pos += self.vel*self.dt
        self.vel = leader_pos - self.pos
        self.vel /= np.linalg.norm(self.vel)
        self.vel *= np.linalg.norm(leader_vel)

class Map:
    def __init__(self, dims, x_min, x_max, y_min, y_max):
        self.map = np.zeros(dims)
        self.dims = dims
        self.x_min = x_min
        self.y_max = y_max
        self.x_range = x_max - x_min
        self.y_range = y_max - y_min

    def clear(self):
        self.map *= 0
    
    def draw(self, actor, id):
        i = int(((self.y_max - actor.pos[1]) / self.y_range) * self.dims[1])
        j = int(((actor.pos[0] - self.x_min) / self.x_range) * self.dims[0])
        self.map[i, j] = id

    def fade(self, frac):
        self.map *= (1.0 - frac)

    def show(self, ax):
        return ax.imshow(self.map)


class Sim:
    def __init__(self, dt):
        self.t = 0
        self.dt = dt
        self.leader = Leader(self.dt)
        self.followers = [Follower(self.dt)]
        self.map = Map((100, 100), -2, 2, -2, 2)

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
    sim = Sim(0.02)
    sim.set_leader_path(
        lambda t: np.array([
            1.5*np.cos(t),
            np.sin(2*t)
        ])
    )
    sim.run_and_show(np.pi*2, fade=0.05)