from abc import ABC, abstractmethod

class VacuumExperiment(ABC):
    @abstractmethod
    def startExp(self, env_info):
        """
        Initialize the experiment with the given environment information.
        This method should set up necessary parameters, establish database connections,
        and prepare the system for the experiment run.

        :param env_info: A dictionary containing environment-specific parameters
        such as database credentials, table names, and experiment settings.
        """

    @abstractmethod
    def step(self):
        """
        Execute a single step or iteration of the experiment.
        This could involve simulating database operations, performing maintenance tasks,
        or collecting metrics.

        :return: A boolean indicating whether the experiment has completed.
        """

    @abstractmethod
    def getTotalAndUsedSpace(self):
        """
        Calculate and return the total and used space by the database or table being tested.
        This is typically used to measure the impact of the experiment on storage.

        :return: A tuple containing the total space and used space.
        """

    @abstractmethod
    def getTupleStats(self):
        """
        Retrieve statistics about the tuples (rows) in the database or table,
        such as the number of live and dead tuples, and other relevant metrics.

        :return: A tuple containing statistics like the number of live tuples, dead tuples, etc.
        """

    @abstractmethod
    def doVacuum(self):
        """
        Perform a vacuum operation on the database or table to clean up dead tuples and
        reclaim space. This method simulates the maintenance activity within the experiment.
        """
